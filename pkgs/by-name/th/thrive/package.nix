{
  lib,
  stdenv,
  fetchFromGitHub,
  godot_4_6-mono,
  dotnet-sdk_10,
  dotnet-runtime_10,
  dotnetCorePackages,
  writableTmpDirAsHomeHook,
  autoPatchelfHook,
  makeWrapper,
  unzip,
  cmake,
  python3,
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
}:

let
  godot = godot_4_6-mono.overrideAttrs (_old: {
    dotnet-sdk = dotnet-sdk_10;
  });

  dotnetRoot = "${dotnet-runtime_10}/share/dotnet";

  godotLinuxExportSuffix =
    if !stdenv.hostPlatform.isLinux then
      ""
    else if stdenv.hostPlatform.isx86_64 then
      "x86_64"
    else if stdenv.hostPlatform.isAarch64 then
      "arm64"
    else
      throw "thrive: unsupported Linux architecture (${stdenv.hostPlatform.system})";
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
      version = "1.0.1.1";

      __structuredAttrs = true;
      strictDeps = true;

      src = fetchFromGitHub {
        owner = "Revolutionary-Games";
        repo = "Thrive";
        rev = "v${finalAttrs.version}";
        fetchSubmodules = true;
        fetchLFS = true;
        hash = "sha256-WnyB842hQTF+gXKQqsdD704vGESfaO2+p7F+ChrXTlY=";
      };

      nativeBuildInputs = [
        godot
        dotnet-sdk_10
        makeWrapper
        unzip
        cmake
        python3
      ]
      ++ lib.optionals stdenv.hostPlatform.isLinux [
        autoPatchelfHook
        writableTmpDirAsHomeHook
      ]
      ++ lib.optional stdenv.hostPlatform.isDarwin writableTmpDirAsHomeHook;

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
      patches = [ ./aarch64-intrinsic.patch ];

      postPatch = ''
        printf '<?xml version="1.0" encoding="utf-8"?>\n<configuration>\n</configuration>\n' > NuGet.Config

        # Simulate Git
        mkdir -p simulation_parameters
        printf '{\n  "Commit": "%s",\n  "Branch": "master",\n  "BuiltAt": "%s",\n  "DevBuild": false\n}\n' \
          "${finalAttrs.src.rev}" "$(date --utc +%FT%T.%NZ)" > simulation_parameters/revision.json

        # Small mismatch in expected version
        substituteInPlace Scripts/GodotVersion.cs --replace-fail \
          'public const string GODOT_VERSION = "4.6"' \
          'public const string GODOT_VERSION = "'"${lib.versions.major godot.version}.${lib.versions.minor godot.version}.${lib.versions.patch godot.version}"'"'
      ''
      + lib.optionalString (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) ''
        substituteInPlace export_presets.cfg --replace-fail 'export_path="builds/Thrive.x86_64"' 'export_path="builds/Thrive.arm64"'
        substituteInPlace export_presets.cfg --replace-fail 'binary_format/architecture="x86_64"' 'binary_format/architecture="arm64"'
      ''
      + lib.optionalString stdenv.hostPlatform.isDarwin ''
        substituteInPlace CMakeLists.txt --replace-fail '-fuse-ld=lld' ""
        substituteInPlace third_party/JoltPhysics/Jolt/Compute/MTL/ComputeSystemMTL.mm --replace-fail MTLPipelineOptionBindingInfo MTLPipelineOptionArgumentInfo
      '';

      # Build native C++ libraries
      preBuild = ''
        export DOTNET_ROOT="${dotnet-sdk_10}/share/dotnet"

        # Doesn't seem to respect even NativeBuildInputs unless we do this
        mkdir -p "$NIX_BUILD_TOP/bin"
        ln -s "${lib.getExe godot}" "$NIX_BUILD_TOP/bin/godot"
        export PATH="$NIX_BUILD_TOP/bin:$PATH"

        dotnet run --project Scripts -- native Build Install \
          --prepare-api-file \
          --debug false \
          --compiler $CXX \
          --c-compiler $CC
      '';

      buildPhase =
        let
          inherit (stdenv.hostPlatform) isLinux isDarwin;
          exportTemplates = "${godot.export-templates-bin}/share/godot/export_templates";

          godotDataDir =
            if isLinux then "$HOME/.local/share/godot" else "$HOME/Library/Application Support/Godot";

          exportPreset = if isLinux then "Linux/X11" else "Mac OSX";
          exportOutput = if isLinux then "Thrive.${godotLinuxExportSuffix}" else "Thrive.zip";

          dotnetRid = dotnetCorePackages.systemToDotnetRid stdenv.hostPlatform.system;
        in
        ''
          runHook preBuild

          mkdir -p "${godotDataDir}"
          rm -rf "${godotDataDir}/export_templates"
          ln -nsf "${exportTemplates}" "${godotDataDir}/export_templates"

          # Compile C# and gather all dependency DLLs for manual placement.
          # Godot's internal --self-contained publish cannot resolve Godot.NET.Sdk/4.6.2
          # in the Nix sandbox (deps.json has 4.6.0), so we publish with --no-self-contained
          # and copy the output into the app bundle ourselves.
          dotnet publish Thrive.csproj \
            --configuration Release \
            --runtime ${dotnetRid} \
            --no-self-contained \
            -o builds/publish

          mkdir -p builds
          godot --headless --export-release "${exportPreset}" "builds/${exportOutput}" ${lib.optionalString isDarwin "&& unzip -q builds/Thrive.zip -d builds"}

          # .NET's DllImport resolves against filesystem paths, not the PCK.
          # Collect all _without_avx dylibs from the build tree and create
          # unadorned symlinks so DllImport("thrive_native") etc. work.
          mkdir -p builds/native
          find native_libs -name "*_without_avx.dylib" -exec cp -v {} builds/native/ \;
          for f in builds/native/*_without_avx.dylib; do
            ln -sf "$(basename "$f")" "builds/native/$(basename "$f" _without_avx.dylib).dylib"
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
        macExe="$macDir/Thrive"
        dataDir="$macAppRoot/Resources/data_Thrive_macos_arm64"

        install -d "$out/Applications" "$out/bin"
        cp -R builds/Thrive.app "$out/Applications/Thrive.app"

        mkdir -p "$dataDir"
        cp -a builds/publish/* "$dataDir/"
        cp -aL "${godot}/libexec/GodotSharp/Api/Release/"* "$dataDir/"

        # hostfxr is dlopen'd from the assembly data dir, not via DOTNET_ROOT
        cp -aL "${dotnetRoot}"/host/fxr/*/libhostfxr.dylib "$dataDir/"

        # hostfxr resolves shared/Microsoft.NETCore.App/ relative to .app bundle root
        mkdir -p "$bundleRoot/shared/Microsoft.NETCore.App"
        for sdk_dir in "${dotnetRoot}/shared/Microsoft.NETCore.App/"*/; do
          ln -sf "$sdk_dir" "$bundleRoot/shared/Microsoft.NETCore.App/$(basename "$sdk_dir")"
        done

        # runtimeconfig may reference 10.0.0; alias the actual version
        ln -sf "$(basename "${dotnetRoot}"/shared/Microsoft.NETCore.App/*/)" \
          "$bundleRoot/shared/Microsoft.NETCore.App/10.0.0"

        for f in builds/native/*; do
          install -Dm644 "$f" "$macDir/$(basename "$f")"
          cp -aL "$f" "$dataDir/"
        done

        mv "$macExe" "$macExe-unwrapped"
        ln -sf ../Resources/Thrive.pck "$macDir/Thrive-unwrapped.pck"

        makeWrapper "$macExe-unwrapped" "$macExe" --set DOTNET_ROOT "${dotnetRoot}"
        makeWrapper "$macExe-unwrapped" "$out/bin/thrive" --set DOTNET_ROOT "${dotnetRoot}"
      ''
      + lib.optionalString stdenv.hostPlatform.isLinux ''
        exe="builds/Thrive.${godotLinuxExportSuffix}"

        install -D -m 755 -t "$out/libexec" "$exe"
        install -D -m 644 -t "$out/libexec" "$exe.pck"

        for f in builds/native/*; do
          install -D -m 644 "$f" "$out/libexec/$(basename "$f")"
        done

        mkdir -p "$out/bin"
        makeWrapper "$out/libexec/Thrive.${godotLinuxExportSuffix}" "$out/bin/thrive" \
          --set DOTNET_ROOT "${dotnetRoot}"
      ''
      + ''
        runHook postInstall
      '';

      postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
        install -D -m 644 assets/misc/icon.png \
          "$out/share/icons/hicolor/256x256/apps/thrive.png"
      '';

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
        platforms = lib.platforms.all;
      };
    })
)
