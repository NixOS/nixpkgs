{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  godot_4_6-mono,
  dotnet-sdk_10,
  dotnet-runtime_10,
  dotnetCorePackages,
  writableTmpDirAsHomeHook,
  autoPatchelfHook,
  makeWrapper,
  ouch,
  cmake,
  python3Minimal,
  alsa-lib,
  libGL,
  libpulseaudio,
  libx11,
  libxcursor,
  libxext,
  libxi,
  libxrandr,
  udev,
  vulkan-loader,
  nix-update-script,
}:

let
  godot = godot_4_6-mono.overrideAttrs {
    dotnet-sdk = dotnet-sdk_10;
  };

  dotnetRoot = "${dotnet-runtime_10}/share/dotnet";

  godotLinuxExportSuffix = lib.optionalString stdenv.hostPlatform.isLinux stdenv.hostPlatform.linuxArch;
in
stdenv.mkDerivation (
  dotnetCorePackages.addNuGetDeps
    {
      nugetDeps = ./deps.json;
      overrideFetchAttrs = old: {
        nativeBuildInputs = lib.remove godot old.nativeBuildInputs;
        dontBuild = false;
        buildPhase = ''
          dotnet restore
        '';
      };
    }
    (finalAttrs: {
      pname = "thrive";
      version = "1.1.0";

      __structuredAttrs = true;
      strictDeps = true;

      src = fetchFromGitHub {
        owner = "Revolutionary-Games";
        repo = "Thrive";
        rev = "v${finalAttrs.version}";
        fetchSubmodules = true;
        fetchLFS = true;
        hash = "sha256-UG65Wx4vaaJV7DXQjrxuyA6L4sPMaGouU/0k1cKUkgU=";
      };

      nativeBuildInputs = [
        godot
        dotnet-sdk_10
        makeWrapper
        ouch
        cmake
        python3Minimal
        writableTmpDirAsHomeHook
      ]
      ++ lib.optionals stdenv.hostPlatform.isLinux [
        autoPatchelfHook
      ];

      buildInputs = lib.optionals stdenv.hostPlatform.isLinux (
        map lib.getLib [
          alsa-lib
          libGL
          libpulseaudio
          libx11
          libxcursor
          libxext
          libxi
          libxrandr
          udev
          vulkan-loader
        ]
      );

      dontUseCmakeConfigure = true;

      patches = [
        # Nix clang on aarch64-darwin lacks __apple_build_version__ and x86 intrinsics.
        ./aarch64-intrinsic.patch

        # We fetchpatch so thrive required godot matches nixpkgs godot (avoiding an override and godot rebuild)
        (fetchpatch {
          url = "https://github.com/Revolutionary-Games/Thrive/commit/51db05dcdb966e39d59fcda370e7a45b45f47c39.patch";
          includes = [
            "Scripts/GodotVersion.cs"
            "Thrive.csproj"
          ];
          hash = "sha256-Jtm5NYZoniCfjWYwJGomUz+/W0bnJBROnA7OHmlqeaw=";
        })
      ];

      postPatch =
        let
          revisionJSON = builtins.toJSON {
            Commit = finalAttrs.src.rev;
            Branch = "master";
            # Stand-in time
            BuiltAt = "2000-01-01T00:00:00Z";
            DevBuild = false;
          };
        in
        ''
          printf '<?xml version="1.0" encoding="utf-8"?>\n<configuration>\n</configuration>\n' > NuGet.Config

          # Simulate Git
          mkdir --parents simulation_parameters
          printf '%s\n' '${revisionJSON}' > simulation_parameters/revision.json

          # Remove hardcoded LLD (more durable to let nix link)
          substituteInPlace CMakeLists.txt --replace-fail '-fuse-ld=lld' ""
        ''
        + lib.optionalString (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) ''
          # Remove the hardcodes (I guess it hasn't been tested for arm?)
          substituteInPlace export_presets.cfg \
            --replace-fail 'export_path="builds/Thrive.x86_64"' 'export_path="builds/Thrive.arm64"' \
            --replace-fail 'binary_format/architecture="x86_64"' 'binary_format/architecture="arm64"'
        ''
        + lib.optionalString stdenv.hostPlatform.isDarwin ''
          substituteInPlace third_party/JoltPhysics/Jolt/Compute/MTL/ComputeSystemMTL.mm --replace-fail MTLPipelineOptionBindingInfo MTLPipelineOptionArgumentInfo
        '';

      # Build native C++ libraries
      preBuild = ''
        # Doesn't seem to respect even NativeBuildInputs unless we do this
        mkdir --parents "$NIX_BUILD_TOP/bin"
        ln --symbolic "${lib.getExe godot}" "$NIX_BUILD_TOP/bin/godot"
        export PATH="$NIX_BUILD_TOP/bin:$PATH"

        export DOTNET_ROOT="${dotnetRoot}"
        dotnet run --project Scripts -- native Build Install \
          --prepare-api-file \
          --debug false \
          --compiler $CXX \
          --c-compiler $CC
      '';

      buildPhase =
        let
          inherit (stdenv.hostPlatform) isLinux isDarwin;
          exportTemplates = godot.export-templates-bin + "/share/godot/export_templates";

          godotDataDir =
            if isLinux then "$HOME/.local/share/godot" else "$HOME/Library/Application Support/Godot";

          exportPreset = if isLinux then "Linux/X11" else "Mac OSX";
          exportOutput = if isLinux then "Thrive.${godotLinuxExportSuffix}" else "Thrive.zip";

          dotnetRid = dotnetCorePackages.systemToDotnetRid stdenv.hostPlatform.system;
        in
        ''
          shopt -s globstar
          runHook preBuild

          mkdir --parents "${godotDataDir}"
          rm --recursive --force "${godotDataDir}/export_templates"
          ln --symbolic --force --no-dereference "${exportTemplates}" "${godotDataDir}/export_templates"

          # Compile C# and gather all dependency DLLs for manual placement.
          # Godot's internal --self-contained publish cannot resolve Godot.NET.Sdk in the sandbox,
          # in the Nix sandbox (deps.json has 4.6.0), so we publish with --no-self-contained
          # and copy the output into the app bundle ourselves.
          dotnet publish Thrive.csproj \
            --configuration Release \
            --runtime ${dotnetRid} \
            --no-self-contained \
            --output builds/publish

          mkdir --parents builds
          godot --headless --export-release "${exportPreset}" "builds/${exportOutput}" ${lib.optionalString isDarwin "&& ouch --yes decompress builds/Thrive.zip --dir builds"}

          # .NET's DllImport resolves against filesystem paths, not the PCK.
          # Collect all _without_avx dylibs from the build tree and create
          # unadorned symlinks so DllImport("thrive_native") etc. work.
          mkdir --parents builds/native

          for filepath in native_libs/**/*_without_avx.dylib; do
            # Protect against empty matches
            [ -e "$filepath" ] || continue

            cp -v "$filepath" builds/native/

            base="''${filepath##*/}"
            ln --symbolic --force "$base" "builds/native/''${base%_without_avx.dylib}.dylib"
          done

          runHook postBuild
        '';

      installPhase = ''
        runHook preInstall
      ''
      + lib.optionalString stdenv.hostPlatform.isDarwin ''
        bundleRoot="$out/Applications/Thrive.app"
        macAppRoot="$bundleRoot/Contents"
        macDir="$macAppRoot/MacOS"
        thriveBin="$macDir/Thrive"
        thriveReal="$macDir/thrive-real"
        dataDir="$macAppRoot/Resources/data_Thrive_macos_arm64"

        install --directory "$out/Applications" "$out/bin"
        cp --recursive builds/Thrive.app "$out/Applications/Thrive.app"

        mkdir --parents "$dataDir"
        cp --archive builds/publish/* "$dataDir/"
        cp --archive --dereference "${godot}/libexec/GodotSharp/Api/Release/"* "$dataDir/"

        # hostfxr is dlopen'd from the assembly data dir, not via DOTNET_ROOT
        cp --archive --dereference "${dotnetRoot}"/host/fxr/*/libhostfxr.dylib "$dataDir/"

        # hostfxr resolves shared/Microsoft.NETCore.App/ relative to .app bundle root
        mkdir --parents "$bundleRoot/shared/Microsoft.NETCore.App"
        ln --symbolic --force "${dotnetRoot}/shared/Microsoft.NETCore.App/"*/ "$bundleRoot/shared/Microsoft.NETCore.App/"

        # runtimeconfig may reference 10.0.0; alias the actual version
        ln --symbolic --force "$(basename "${dotnetRoot}"/shared/Microsoft.NETCore.App/*/)" \
          "$bundleRoot/shared/Microsoft.NETCore.App/10.0.0"

        for file in builds/native/*; do
          install -D --mode 644 "$file" "$macDir/$(basename "$file")"
          cp --archive --dereference "$file" "$dataDir/"
        done

        # Godot loads the .pck from beside the real binary, not the wrapper.
        mv "$thriveBin" "$thriveReal"
        ln --symbolic --force ../Resources/Thrive.pck "$thriveReal.pck"

        # Wrap both with proper DOTNET_ROOT
        for thriveWrapper in "$thriveBin" "$out/bin/thrive"; do
          makeWrapper "$thriveReal" "$thriveWrapper" --set DOTNET_ROOT "${dotnetRoot}"
        done
      ''
      + lib.optionalString stdenv.hostPlatform.isLinux ''
        exe="builds/Thrive.${godotLinuxExportSuffix}"

        install -D --mode 755 --target-directory "$out/libexec" "$exe"
        install -D --mode 644 --target-directory "$out/libexec" "$exe.pck" builds/native/*
        install -D --mode 644 assets/misc/icon.png "$out/share/icons/hicolor/256x256/apps/thrive.png"

        mkdir --parents "$out/bin"
        makeWrapper "$out/libexec/Thrive.${godotLinuxExportSuffix}" "$out/bin/thrive" \
          --set DOTNET_ROOT "${dotnetRoot}"
      ''
      + ''
        runHook postInstall
      '';

      passthru = {
        updateScript = nix-update-script { };
      };

      meta = {
        description = "Evolution simulation game about surviving as a microbe on an alien world";
        longDescription = ''
          Thrive is an open-source evolution simulation. The player starts as a microbe on an alien world and
          adapts to survive in a sandbox science setting. Gameplay includes cell stage mechanics, strategy
          elements, and scientific inspiration from biology. The source project uses the Godot engine with C#.
        '';
        homepage = "https://revolutionarygamesstudio.com/";
        changelog = "https://github.com/Revolutionary-Games/Thrive/releases/tag/v${finalAttrs.version}";
        license = lib.licenses.gpl3Plus;
        maintainers = with lib.maintainers; [ philocalyst ];
        mainProgram = "thrive";
        platforms = with lib.platforms; darwin ++ linux;
      };
    })
)
