{
  lib,
  stdenv,
  callPackage,
  runCommand,
  makeWrapper,
  writeText,
  wrapGAppsHook3,
  buildDartApplication,
  cacert,
  glib,
  flutter,
  pkg-config,
  buildPackages,
  cocoapods,
  gitMinimal,
  darwin,
  rsync,
  writeShellScriptBin,
  xcode ? darwin.xcode_27,
}:

let
  defaultTargetFlutterPlatform = if stdenv.hostPlatform.isDarwin then "macos" else "linux";
  projectRuby = cocoapods.wrappedRuby;
  writableRsync = writeShellScriptBin "rsync" ''
    # Embedding vendored frameworks must not preserve read-only store permissions.
    exec ${lib.getExe rsync} --chmod=u+w "$@"
  '';
  podTools = writeShellScriptBin "pod" ''
    # Flutter chooses CocoaPods only when the project or its plugins need it.
    # Prepare its generated Podfile immediately before installation.
    for arg in "$@"; do
      if [ "$arg" = install ]; then
        ${projectRuby}/bin/ruby ${./setup-macos.rb} \
          ${lib.escapeShellArg stdenv.hostPlatform.darwinMinVersion} --podfile
        break
      fi
    done
    exec ${cocoapods}/bin/pod "$@"
  '';
  xcodeTools = writeShellScriptBin "xcrun" ''
    if [ "$1" = xcodebuild ]; then
      shift
      # SwiftPM's sandbox cannot be nested inside the Nix sandbox.
      exec "${xcode}/Contents/Developer/usr/bin/xcodebuild" \
        -IDEPackageSupportDisableManifestSandbox=1 \
        -IDEPackageSupportDisablePluginExecutionSandbox=1 "$@"
    fi
    exec /usr/bin/xcrun "$@"
  '';
in

lib.extendMkDerivation {
  excludeDrvArgNames = [ "swiftPackages" ];
  constructDrv =
    argsFn:
    let
      evalArgs = lib.fix argsFn;
      targetFlutterPlatform = evalArgs.targetFlutterPlatform or defaultTargetFlutterPlatform;

      minimalFlutter = flutter.override {
        supportedTargetFlutterPlatforms = [
          "universal"
          targetFlutterPlatform
        ];
      };

      buildAppWith = flutter: buildDartApplication.override { dart = flutter; };
    in
    buildAppWith minimalFlutter (
      finalAttrs:
      let
        args = argsFn finalAttrs;
      in
      args
      // {
        passthru = (args.passthru or { }) // {
          multiShell = buildAppWith flutter args;
        };
      }
    );

  extendDrvArgs =
    finalAttrs:
    args@{
      pubGetScript ? null,
      swiftPackages ? { },
      flutterBuildFlags ? [ ],
      targetFlutterPlatform ? defaultTargetFlutterPlatform,
      extraWrapProgramArgs ? "",
      flutterMode ? null,
      ...
    }:
    let
      hasEngine = flutter ? engine && flutter.engine != null && flutter.engine.meta.available;
      flutterMode' = args.flutterMode or (if hasEngine then flutter.engine.runtimeMode else "release");

      flutterFlags = lib.optional hasEngine "--local-engine host_${flutterMode'}${
        lib.optionalString (!flutter.engine.isOptimized) "_unopt"
      }";

      flutterBuildFlags' = [
        "--${flutterMode'}"
      ]
      ++ (args.flutterBuildFlags or [ ])
      ++ flutterFlags;

      universal = removeAttrs args [ "swiftPackages" ] // {
        inherit targetFlutterPlatform;
        flutterMode = flutterMode';
        flutterFlags = flutterFlags;
        flutterBuildFlags = flutterBuildFlags';

        sdkSetupScript = ''
          # Pub needs SSL certificates. Dart normally looks in a hardcoded path.
          # https://github.com/dart-lang/sdk/blob/3.1.0/runtime/bin/security_context_linux.cc#L48
          #
          # Dart does not respect SSL_CERT_FILE...
          # https://github.com/dart-lang/sdk/issues/48506
          # ...and Flutter does not support --root-certs-file, so the path cannot be manually set.
          # https://github.com/flutter/flutter/issues/56607
          # https://github.com/flutter/flutter/issues/113594
          #
          # libredirect is of no use either, as Flutter does not pass any
          # environment variables (including LD_PRELOAD) to the Pub process.
          #
          # Instead, Flutter is patched to allow the path to the Dart binary used for
          # Pub commands to be overriden.
          export NIX_FLUTTER_PUB_DART="${
            runCommand "dart-with-certs" { nativeBuildInputs = [ makeWrapper ]; } ''
              mkdir -p "$out/bin"
              makeWrapper ${flutter.dart}/bin/dart "$out/bin/dart" \
                --add-flags "--root-certs-file=${cacert}/etc/ssl/certs/ca-bundle.crt"
            ''
          }/bin/dart"

          export HOME="$NIX_BUILD_TOP"
          flutter config $flutterFlags --no-analytics &>/dev/null # mute first-run
          ${lib.optionalString
            (builtins.elem targetFlutterPlatform [
              "linux"
              "macos"
            ])
            ''
              flutter config $flutterFlags --enable-${targetFlutterPlatform}-desktop >/dev/null
            ''
          }
        '';

        pubGetScript =
          args.pubGetScript
            or "flutter${lib.optionalString hasEngine " --local-engine $flutterMode"} pub get";

        sdkSourceBuilders = {
          # https://github.com/dart-lang/pub/blob/68dc2f547d0a264955c1fa551fa0a0e158046494/lib/src/sdk/flutter.dart#L81
          "flutter" =
            name:
            runCommand "flutter-sdk-${name}" { passthru.packageRoot = "."; } ''
              for path in '${flutter}/packages/${name}' '${flutter}/bin/cache/pkg/${name}'; do
                if [ -d "$path" ]; then
                  ln -s "$path" "$out"
                  break
                fi
              done

              if [ ! -e "$out" ]; then
                echo 1>&2 'The Flutter SDK does not contain the requested package: ${name}!'
                exit 1
              fi
            '';
          # https://github.com/dart-lang/pub/blob/e1fbda73d1ac597474b82882ee0bf6ecea5df108/lib/src/sdk/dart.dart#L80
          "dart" =
            name:
            runCommand "dart-sdk-${name}" { passthru.packageRoot = "."; } ''
              for path in '${flutter.dart}/pkg/${name}'; do
                if [ -d "$path" ]; then
                  ln -s "$path" "$out"
                  break
                fi
              done

              if [ ! -e "$out" ]; then
                echo 1>&2 'The Dart SDK does not contain the requested package: ${name}!'
                exit 1
              fi
            '';
        };

        # https://github.com/flutter/flutter/blob/edada7c56edf4a183c1735310e123c7f923584f1/packages/flutter_tools/lib/src/dart/pub.dart#L804
        extraPackageConfigSetup = lib.optionalString (lib.versionOlder flutter.version "3.34.0") ''
          if [ "$("${lib.getExe buildPackages.yq}" '.flutter.generate // false' pubspec.yaml)" = "true" ]; then
            if ! "${lib.getExe buildPackages.jq}" -e '.packages[] | select(.name == "flutter_gen")' "$out" >/dev/null 2>&1; then
              export TEMP_PACKAGES=$(mktemp)
              "${lib.getExe buildPackages.jq}" '.packages |= . + [{
                name: "flutter_gen",
                rootUri: "flutter_gen",
                languageVersion: "2.12"
              }]' "$out" > "$TEMP_PACKAGES"
              cp "$TEMP_PACKAGES" "$out"
              rm "$TEMP_PACKAGES"
              unset TEMP_PACKAGES
            fi
          fi
        '';
      };
    in
    {
      inherit universal;

      linux = universal // {
        outputs = universal.outputs or [ ] ++ [ "debug" ];

        nativeBuildInputs = (universal.nativeBuildInputs or [ ]) ++ [
          wrapGAppsHook3

          # Flutter requires pkg-config for Linux desktop support, and many plugins
          # attempt to use it.
          #
          # It is available to the `flutter` tool through its wrapper, but it must be
          # added here as well so the setup hook adds plugin dependencies to the
          # pkg-config search paths.
          pkg-config
        ];

        buildInputs = (universal.buildInputs or [ ]) ++ [ glib ];

        dontDartBuild = true;
        buildPhase =
          universal.buildPhase or ''
            runHook preBuild

            mkdir -p build/flutter_assets/fonts

            flutter build linux -v --split-debug-info="$debug" $flutterBuildFlags

            runHook postBuild
          '';

        dontDartInstall = true;
        installPhase =
          universal.installPhase or ''
            runHook preInstall

            built=build/linux/*/$flutterMode/bundle

            mkdir -p $out/bin
            mkdir -p $out/app
            mv $built $out/app/$pname

            for f in $(find $out/app/$pname -iname "*.desktop" -type f); do
              install -D $f $out/share/applications/$(basename $f)
            done

            for f in $(find $out/app/$pname -maxdepth 1 -type f); do
              ln -s $f $out/bin/$(basename $f)
            done

            # make *.so executable
            find $out/app/$pname -iname "*.so" -type f -exec chmod +x {} +

            # remove stuff like /build/source/packages/ubuntu_desktop_installer/linux/flutter/ephemeral
            for f in $(find $out/app/$pname -executable -type f); do
              if patchelf --print-rpath "$f" | grep /build; then # this ignores static libs (e,g. libapp.so) also
                echo "strip RPath of $f"
                newrp=$(patchelf --print-rpath $f | sed -r "s|/build.*ephemeral:||g" | sed -r "s|/build.*profile:||g")
                patchelf --set-rpath "$newrp" "$f"
              fi
            done

            runHook postInstall
          '';

        dontWrapGApps = true;
        extraWrapProgramArgs = ''
          ''${gappsWrapperArgs[@]} \
          ${extraWrapProgramArgs}
        '';
      };

      macos =
        assert stdenv.hostPlatform.isDarwin;
        universal
        // {
          outputs = (universal.outputs or [ ]) ++ [ "debug" ];

          nativeBuildInputs = (universal.nativeBuildInputs or [ ]) ++ [
            cocoapods
            gitMinimal
            darwin.DarwinTools
          ];

          sdkSetupScript = universal.sdkSetupScript;

          # Xcode uses LaunchServices to identify .xcworkspace bundles.
          sandboxProfile = (universal.sandboxProfile or "") + ''
            (allow mach-lookup (global-name "com.apple.lsd.mapdb"))
          '';

          dontDartBuild = true;
          buildPhase =
            universal.buildPhase or ''
              runHook preBuild

              # xcbuild cannot build modern Flutter Xcode projects. Use the full
              # Xcode toolchain, including its Swift compiler and SDK.
              export DEVELOPER_DIR="${xcode}/Contents/Developer"
              export PATH="${podTools}/bin:${writableRsync}/bin:${xcodeTools}/bin:$DEVELOPER_DIR/usr/bin:$DEVELOPER_DIR/Toolchains/XcodeDefault.xctoolchain/usr/bin:$PATH"
              export NIX_FLUTTER_SWIFT_PACKAGES=${
                writeText "flutter-swift-packages.json" (builtins.toJSON (lib.mapAttrs (_: toString) swiftPackages))
              }
              export SDKROOT=macosx
              export FLUTTER_XCODE_ARCHS="''${FLUTTER_XCODE_ARCHS:-${stdenv.hostPlatform.darwinArch}}"
              # Xcode's LD setting expects a compiler driver, whereas stdenv's
              # LD names the linker itself. Let Xcode select its own tools.
              unset CC CXX LD LDPLUSPLUS AR AS NM RANLIB STRIP
              # Foundation uses the account's home directory unless this is set;
              # Nix build users have /var/empty as their home.
              export CFFIXED_USER_HOME="$NIX_BUILD_TOP"
              export XDG_CACHE_HOME="$NIX_BUILD_TOP/.cache"
              export CLANG_MODULE_CACHE_PATH="$NIX_BUILD_TOP/clang-module-cache"
              export SWIFTPM_MODULECACHE_OVERRIDE="$NIX_BUILD_TOP/swift-module-cache"
              export COCOAPODS_DISABLE_STATS=true
              # Xcode projects and podspecs can contain Unicode under Nix's C locale.
              export RUBYOPT="''${RUBYOPT:+$RUBYOPT }-EUTF-8"
              export FLUTTER_XCODE_CODE_SIGN_IDENTITY=-
              export FLUTTER_XCODE_CODE_SIGNING_REQUIRED=NO
              export FLUTTER_XCODE_DEVELOPMENT_TEAM=
              export FLUTTER_XCODE_PROVISIONING_PROFILE=
              export FLUTTER_XCODE_PROVISIONING_PROFILE_SPECIFIER=
              export FLUTTER_XCODE_OTHER_CODE_SIGN_FLAGS=--deep

              mkdir -p build/flutter_assets/fonts "$debug"
              ${projectRuby}/bin/ruby ${./setup-macos.rb} \
                ${lib.escapeShellArg stdenv.hostPlatform.darwinMinVersion}
              flutter build macos -v --split-debug-info="$debug" $flutterBuildFlags

              runHook postBuild
            '';

          dontDartInstall = true;
          installPhase =
            universal.installPhase or ''
              runHook preInstall

              mkdir -p "$out/Applications" "$out/bin"
              # Configuration names may contain a flavor, and bundle names need
              # not match pname. Only inspect the top-level build products.
              shopt -s nullglob
              apps=(build/macos/Build/Products/*/*.app)
              if [ "''${#apps[@]}" -ne 1 ]; then
                echo "Expected one macOS application bundle, found ''${#apps[@]}" >&2
                exit 1
              fi
              appName=$(basename "''${apps[0]}")
              mv "''${apps[0]}" "$out/Applications/$appName"
              executable=$(/usr/libexec/PlistBuddy -c 'Print :CFBundleExecutable' \
                "$out/Applications/$appName/Contents/Info.plist")
              ln -s "$out/Applications/$appName/Contents/MacOS/$executable" "$out/bin/$pname"

              runHook postInstall
            '';

          doInstallCheck = universal.doInstallCheck or true;
          installCheckPhase =
            universal.installCheckPhase or ''
              runHook preInstallCheck

              apps=("$out/Applications/"*.app)
              test "''${#apps[@]}" -gt 0
              for app in "''${apps[@]}"; do
                executable=$(/usr/libexec/PlistBuddy -c 'Print :CFBundleExecutable' "$app/Contents/Info.plist")
                test -x "$app/Contents/MacOS/$executable"
                /usr/bin/codesign --verify --deep --strict "$app"
              done

              runHook postInstallCheck
            '';

          postFixup =
            (universal.postFixup or "")
            + "\n"
            + ''
              # Flutter thins and edits the prebuilt engine framework. Refresh
              # nested signatures after all fixups, preserving app entitlements.
              for app in "$out/Applications/"*.app; do
                /usr/bin/codesign --force --deep --sign - \
                  --preserve-metadata=entitlements,flags,runtime "$app"
                # Ad-hoc signatures have no Apple Team ID. Hardened apps must
                # allow their Nix-built frameworks while retaining other flags.
                while IFS= read -r -d "" bundle; do
                  if /usr/bin/codesign --display --verbose "$bundle" 2>&1 | grep -q 'flags=.*runtime'; then
                    entitlements=$(mktemp)
                    /usr/bin/codesign --display --entitlements - --xml "$bundle" > "$entitlements" 2>/dev/null
                    if [ ! -s "$entitlements" ]; then
                      echo '<?xml version="1.0"?><plist version="1.0"><dict/></plist>' > "$entitlements"
                    fi
                    /usr/libexec/PlistBuddy -c 'Set :com.apple.security.cs.disable-library-validation true' "$entitlements" 2>/dev/null || \
                      /usr/libexec/PlistBuddy -c 'Add :com.apple.security.cs.disable-library-validation bool true' "$entitlements"
                    /usr/bin/codesign --force --sign - --entitlements "$entitlements" \
                      --preserve-metadata=flags,runtime "$bundle"
                  else
                    /usr/bin/codesign --force --sign - \
                      --preserve-metadata=entitlements,flags,runtime "$bundle"
                  fi
                done < <(find "$app" -depth -type d \( -name '*.app' -o -name '*.appex' \) -print0)
              done
            '';
        };

      web = universal // {
        dontDartBuild = true;
        buildPhase =
          universal.buildPhase or ''
            runHook preBuild

            mkdir -p build/flutter_assets/fonts

            flutter build web -v $flutterBuildFlags

            runHook postBuild
          '';

        dontDartInstall = true;
        installPhase =
          universal.installPhase or ''
            runHook preInstall

            cp -r build/web "$out"

            runHook postInstall
          '';
      };
    }
    .${targetFlutterPlatform} or (throw "Unsupported Flutter host platform: ${targetFlutterPlatform}");
}
