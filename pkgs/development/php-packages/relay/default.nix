{
  stdenv,
  lib,
  fetchurl,
  php,
  openssl,
  hiredis,
  libck,
  zstd,
  lz4,
  autoPatchelfHook,
  writeShellScript,
  runCommand,
  curl,
  common-updater-scripts,
}:

let
  version = "0.61.0";
  hashes = {
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      hash = {
        "8.1" = "sha256-z7Pl+9Ce+kpDIdOrU0r6bqRFRuZL1mC8uirgvgQH4g4=";
        "8.2" = "sha256-t5qQ4AV27O2MkbuKRuT8SAymQTnlXHEgZI7ROTUcr6Y=";
        "8.3" = "uOuyj/gDdRD/L6vstyqBZ7N/asPiuySas7C04OrTuBU=";
        "8.4" = "sha256-p1ctc4CM+ZbKl4aSdcZovy3ZRjzps/ugtmXNcr+UoHY=";
        "8.5" = "87RNGFoFKueyjpZJEtsFoqEFfyd4ajQ7SEgqtmN5XR8=";
      };
    };
    "aarch64-linux" = {
      platform = "debian-aarch64+libssl3";
      hash = {
        "8.1" = "sha256-Le3zp4h4afO3YI0rnQbRt9mMKybj6BArei9vtVg48jA=";
        "8.2" = "sha256-DzVPhfpF2mKD5Wsqi/ZzN+wj4twO529hteneHWUHW+I=";
        "8.3" = "sha256-cPx6Nb8aD0iCbWmT7RbHmScNGGUAR75auh6kiVKFc1Q=";
        "8.4" = "QPM9BQ7e+4IBPtu5lLY4vVQ0kdWIFw7/+bp6jl2kOOw=";
        "8.5" = "8OOHdjJJe6CHuRwYNVbF3X0uY4GVTIPCtgDBPx9KiHM=";
      };
    };
    "x86_64-linux" = {
      platform = "debian-x86-64+libssl3";
      hash = {
        "8.1" = "sha256-IOksa1pbNIua45k9Fx01XFUh7vTdLVGQML1k1iytFwk=";
        "8.2" = "sha256-cwR5lBYIDXwKaQ2fBc/NL1bYahakwdg/xOYmmPClbkI=";
        "8.3" = "sha256-s/bezJBSfeSWhCHnASB14y5VK4EPF54YLrAtoNYHiV8=";
        "8.4" = "5b9aEf+UphIFesF/tZ6SxAZA2MeajZLlTolAuwFX1gA=";
        "8.5" = "orU3oMZvrPlaWOE/12NAa4b5q8ejjc+o3KgabVTTLzI=";
      };
    };
  };

  makeSource =
    { system, phpMajor }:
    fetchurl {
      url =
        "https://builds.r2.relay.so/v${version}/relay-v${version}-php"
        + phpMajor
        + "-"
        + hashes.${system}.platform
        + ".tar.gz";
      sha256 =
        hashes.${system}.hash.${phpMajor}
          or (throw "Unsupported PHP version for relay ${phpMajor} on ${system}");
    };
in
stdenv.mkDerivation (finalAttrs: {
  inherit version;
  pname = "relay";
  extensionName = "relay";

  src = makeSource {
    system = stdenv.hostPlatform.system;
    phpMajor = lib.versions.majorMinor php.version;
  };
  nativeBuildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [ autoPatchelfHook ];
  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [
    hiredis
    libck
    openssl
    zstd
    lz4
  ];
  internalDeps = [ php.extensions.session ];
  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    # Temporary patch as relay isn't compatible with the latest version of hiredis out of
    # the box.
    patchelf \
      --replace-needed libhiredis.so.1.1.0 libhiredis.so.1 \
      --replace-needed libhiredis_ssl.so.1.1.0 libhiredis_ssl.so.1 \
        relay.so
  ''
  + ''
    install -Dm755 relay.so -t $out/lib/php/extensions
  ''
  + (
    if stdenv.hostPlatform.isDarwin then
      # fixDarwinDylibNames can't be used here because we need to completely remap .dylibs, not just add
      # absolute paths. Rather than hardcoding the Homebrew paths and versions relay.so happens to be
      # linked against (which silently goes stale whenever relay or one of these libraries updates),
      # discover the actual references via otool and remap them by matching their basename.
      ''
        for dylib in $(otool -L $out/lib/php/extensions/relay.so | tail -n +2 | awk '{print $1}' | grep '^/opt/homebrew/'); do
          base=$(basename "$dylib")
          case "$base" in
            libhiredis_ssl.*) dir="${lib.makeLibraryPath [ hiredis ]}" ;;
            libhiredis.*) dir="${lib.makeLibraryPath [ hiredis ]}" ;;
            libssl.*) dir="${lib.makeLibraryPath [ openssl ]}" ;;
            libcrypto.*) dir="${lib.makeLibraryPath [ openssl ]}" ;;
            libzstd.*) dir="${lib.makeLibraryPath [ zstd ]}" ;;
            liblz4.*) dir="${lib.makeLibraryPath [ lz4 ]}" ;;
            libck.*) dir="${lib.makeLibraryPath [ libck ]}" ;;
            *)
              echo "relay.so references unrecognized Homebrew library $dylib; add a mapping for it" >&2
              exit 1
              ;;
          esac
          install_name_tool -change "$dylib" "$dir/$base" $out/lib/php/extensions/relay.so
        done
      ''
    else
      ""
  )
  + ''
    # Random UUID that's required by the extension. Can be anything, but must be different from default.
    sed -i "s/00000000-0000-0000-0000-000000000000/aced680f-30e9-40cc-a868-390ead14ba0c/" $out/lib/php/extensions/relay.so
    chmod -w $out/lib/php/extensions/relay.so

    runHook postInstall
  '';

  passthru = {
    tests.smokeTest = runCommand "php-relay-smoke-test" { } ''
      ${lib.getExe php} \
        -d extension=${finalAttrs.finalPackage}/lib/php/extensions/relay.so \
        -r 'exit(extension_loaded("relay") ? 0 : 1);'
      touch $out
    '';

    updateScript = writeShellScript "update-${finalAttrs.pname}" ''
      set -o errexit
      export PATH="$PATH:${
        lib.makeBinPath [
          curl
          common-updater-scripts
        ]
      }"
      NEW_VERSION=$(curl --silent https://builds.r2.relay.so/meta/builds | sort -V | tail -n1 | cut -c2-)

      if [[ "${version}" = "$NEW_VERSION" ]]; then
          echo "The new version same as the old version."
          exit 0
      fi

      for source in ${lib.concatStringsSep " " (builtins.attrNames finalAttrs.passthru.updateables)}; do
        update-source-version "$UPDATE_NIX_ATTR_PATH.updateables.$source" "$NEW_VERSION" --ignore-same-version --ignore-same-hash --print-changes
      done
    '';

    # All sources for updating by the update script.
    updateables =
      builtins.listToAttrs
        # Collect all leaf attributes (containing hashes).
        (
          lib.collect (attrs: attrs ? name)
            # create an attr containing
            (
              lib.mapAttrsRecursive (
                path: _value:
                lib.nameValuePair (builtins.replaceStrings [ "." ] [ "_" ] (lib.concatStringsSep "_" path)) (
                  finalAttrs.finalPackage.overrideAttrs (attrs: {
                    src = makeSource {
                      system = builtins.head path;
                      phpMajor = builtins.head (builtins.tail (builtins.tail path));
                    };
                  })
                )
              ) (lib.filterAttrsRecursive (name: _value: name != "platform") hashes)
            )
        );
  };

  meta = {
    description = "Next-generation Redis extension for PHP";
    changelog = "https://github.com/cachewerk/relay/releases/tag/v${version}";
    homepage = "https://relay.so/";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      tillkruss
      ostrolucky
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
})
