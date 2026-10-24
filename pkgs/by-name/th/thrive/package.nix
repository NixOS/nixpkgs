{
  lib,
  stdenv,
  fetchFromGitHub,
  godot_4_7-mono,
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
  libxfixes,
  libxi,
  libxinerama,
  libxkbcommon,
  libxrandr,
  libxrender,
  libdecor,
  wayland,
  udev,
  vulkan-loader,
  nix-update-script,
}:

let
  godot = godot_4_7-mono.overrideAttrs {
    dotnet-sdk = dotnet-sdk_10;
  };

  dotnetRoot = "${dotnet-runtime_10}/share/dotnet";

  godotLinuxArchitecture =
    if stdenv.hostPlatform.isx86_64 then
      "x86_64"
    else if stdenv.hostPlatform.isAarch64 then
      "arm64"
    else
      throw "thrive: unsupported Linux architecture (${stdenv.hostPlatform.system})";

  godotLinuxExportSuffix = lib.optionalString stdenv.hostPlatform.isLinux godotLinuxArchitecture;

  # The exported executable has no RUNPATH for libraries loaded by Godot's
  # display drivers through dlopen (X11, Wayland, and EGL).
  linuxRuntimeLibs = [
    alsa-lib
    libGL
    libpulseaudio
    libx11
    libxcursor
    libxext
    libxfixes
    libxi
    libxinerama
    libxkbcommon
    libxrandr
    libxrender
    libdecor
    wayland
    udev
    vulkan-loader
  ];
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
      version = "1.6.0";

      __structuredAttrs = true;
      strictDeps = true;

      src = fetchFromGitHub {
        owner = "Revolutionary-Games";
        repo = "Thrive";
        rev = "v${finalAttrs.version}";
        fetchSubmodules = true;
        fetchLFS = true;
        hash = "sha256-dcssA2FfjBZ3a7WtTYwVBxpzfY/8+BN5OcFGn59xlBM=";
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
      ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

      buildInputs = lib.optionals stdenv.hostPlatform.isLinux (map lib.getLib linuxRuntimeLibs);

      dontUseCmakeConfigure = true;

      patches = [
        # Nix clang on aarch64-darwin lacks __apple_build_version__ and x86 intrinsics.
        ./aarch64-intrinsic.patch
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

          # FORCE_INLINE already expands to inline on GCC and Clang.
          substituteInPlace src/native/core/RefCounted.hpp \
            --replace-fail 'FORCE_INLINE inline' 'FORCE_INLINE'
          substituteInPlace src/native/physics/PhysicalWorld.cpp \
            --replace-fail 'reinterpret_cast<decltype(STUFFED_POINTER_DATA_MASK)>(body.get())' \
              'reinterpret_cast<uint64_t>(body.get())'

          # Remove hardcoded LLD (more durable to let nix link)
          substituteInPlace CMakeLists.txt --replace-fail '-fuse-ld=lld' ""
        ''
        + lib.optionalString (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) ''
          # Remove the hardcodes (I guess it hasn't been tested for arm?)
          substituteInPlace export_presets.cfg \
            --replace-fail 'export_path="builds/Thrive.x86_64"' 'export_path="builds/Thrive.arm64"' \
            --replace-fail 'binary_format/architecture="x86_64"' 'binary_format/architecture="arm64"'
        ''
        + lib.optionalString stdenv.hostPlatform.isLinux ''
          # CMake incorrectly passes CMAKE_STATIC_LINKER_FLAGS to ar.
          substituteInPlace CMakeLists.txt \
            --replace-fail 'set(CMAKE_STATIC_LINKER_FLAGS "''${CMAKE_STATIC_LINKER_FLAGS} -fuse-ld=gold")' ""
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
          --disable-avx \
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
          # Collect all platform native libraries from the build tree and create
          # unadorned symlinks so DllImport("thrive_native") etc. work.
          mkdir --parents builds/native

          nativeExtension=${if isLinux then "so" else "dylib"}
          for filepath in native_libs/**/*_without_avx."$nativeExtension"; do
            # Protect against empty matches
            [ -e "$filepath" ] || continue

            cp -v "$filepath" builds/native/

            base="''${filepath##*/}"
            ln --symbolic --force "$base" "builds/native/''${base%_without_avx.$nativeExtension}.$nativeExtension"
          done

          # The GDExtension installer places this library in the project-root
          # lib/ directory, not under native_libs/.
          if [ -e "lib/libthrive_extension_without_avx.$nativeExtension" ]; then
            cp -v "lib/libthrive_extension_without_avx.$nativeExtension" builds/native/
          fi

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
        mkdir --parents "$out/libexec/lib"
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
        dataDir="$out/libexec/data_Thrive_linuxbsd_${godotLinuxArchitecture}"

        install -D --mode 755 --target-directory "$out/libexec" "$exe"
        # Godot names the resource pack after the project, not the architecture-suffixed executable.
        install -D --mode 644 --target-directory "$out/libexec" builds/Thrive.pck
        mkdir --parents "$dataDir"
        cp --archive builds/publish/* "$dataDir/"
        cp --archive --dereference "${godot}/libexec/GodotSharp/Api/Release/"* "$dataDir/"
        hostfxrPath="$(realpath "${dotnetRoot}"/host/fxr/*/libhostfxr.so)"
        # Keep the flat path Godot probes, but load the same canonical runtime
        # library first so hostfxr can infer dotnet_root from its real location.
        ln --symbolic "$hostfxrPath" "$dataDir/libhostfxr.so"
        for file in builds/native/*; do
          install -D --mode 644 "$file" "$out/libexec/lib/$(basename "$file")"
          cp --archive --dereference "$file" "$dataDir/"
        done
        install -D --mode 644 assets/misc/icon.png "$out/share/icons/hicolor/256x256/apps/thrive.png"

        mkdir --parents "$out/bin"
        makeWrapper "$out/libexec/Thrive.${godotLinuxExportSuffix}" "$out/bin/thrive" \
          --set DOTNET_ROOT "${dotnetRoot}" \
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath linuxRuntimeLibs}" \
          --prefix LD_PRELOAD : "$hostfxrPath" \
          --run "cd $out/libexec"
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
