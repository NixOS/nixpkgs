{ stdenv
, lib
, fetchFromGitHub
, jq
, curl
, cacert
, zlib
, icu
, libunwind
, libuuid
, openssl
, lttng-ust_2_12
, buildFHSUserEnv
, writeScript
, mkNugetDeps
, mkNugetSource
, dotnetPackages
, writeText
, strace
, glibcLocales
, runCommand
, fetchurl
, unzip
, zip
, wget
, git
, clangStdenv
, python3
, cmake
, libkrb5
, llvm
, pkg-config
, testers
, dotnet-sdk
, buildNetSdk
, dotnetCorePackages
}:

let
  rids = { "x86_64-linux" = "linux-x64"; };

  binary-rpath = lib.makeLibraryPath ([
    stdenv.cc.cc
    zlib
    curl
    icu
    libunwind
    libuuid
    openssl
  ] ++ lib.optional stdenv.isLinux lttng-ust_2_12);

  bootstrap-sdk = buildNetSdk {
    inherit icu;
    version = "6.0.107";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/1cf99a7b-0eb2-42b1-8902-7ba3bbc825c2/05c48fc1df50db04762a852b321779ce/dotnet-sdk-6.0.107-linux-x64.tar.gz";
        sha512  = "cd03b0a04230371c5c6cc9368722123771a80e38f9a7dad9f831263b319821139d68e37f6e0321487f5fde86e96985965a12f0b3a74fe05d1e917d587775950f";
      };
    };
    packages = { fetchNuGet }: [];
  } // {
    packages = let
      artifacts = fetchurl {
        url = "https://dotnetcli.azureedge.net/source-built-artifacts/assets/Private.SourceBuilt.Artifacts.6.0.107.tar.gz";
        sha256 = "14mzn2wy6ny5n94f93gdbm0p7scx6qjph8n3bm2p8vnwkhbq35gw";
      };

      in stdenv.mkDerivation {
        name = artifacts.name;

        src = artifacts;

        sourceRoot = ".";

        nativeBuildInputs = [ unzip zip ];

        postPatch = ''
          for x in *.linux-x64.*.nupkg
          do
            mkdir .patch
            pushd .patch
            unzip -q ../"$x"
            chmod -R +rw .
            for p in $(find -type f); do
              if isELF "$p"; then
                echo "Patchelfing $p"
                patchelf \
                  --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" \
                  "$p" ||:
                patchelf \
                  --set-rpath "${binary-rpath}" \
                  "$p" ||:
              fi
            done
            # Sets all timestamps to Jan 1 1980, the earliest mtime zips support.
            find -exec touch -t 198001010000.00 {} +
            zip -r ../"$x" .
            popd
            rm -rf .patch
          done
        '';

        installPhase = ''
          cp -Tr . $out
        '';
      };
  };

  dotnet-sdk-src = runCommand "dotnet-build-src" ({
    outputHashAlgo = "sha256";
    outputHash = "sha256-xnRd0ctsDrWGKca1xCArUz7J16P48Awnc7T3r6BnP+c=";
    outputHashMode = "recursive";
    nativeBuildInputs = [
      wget
      cacert
      git
      jq
    ];
    src = fetchFromGitHub {
      owner = "dotnet";
      repo = "installer";
      rev = "refs/tags/v6.0.108";
      sha256 = "sha256-ssGp9OiunlLXuVw1kpSxYzh7GbkO0AaMpDPqVZFyw+U=";
      leaveDotGit = true;
    };
    DOTNET_INSTALL_DIR = bootstrap-sdk;
    # https://github.com/NixOS/nixpkgs/issues/38991
    # bash: warning: setlocale: LC_ALL: cannot change locale (en_US.UTF-8)
    LOCALE_ARCHIVE = lib.optionalString stdenv.isLinux
        "${glibcLocales}/lib/locale/locale-archive";
  }) ''
    cp -Tr "$src" src
    chmod -R +w src
    cd src
    git remote add origin https://github.com/dotnet/installer.git
    patch -p1 < ${./0001-make-tarball-deterministic.patch}
    jq '.tools=(.tools|.dotnet="6.0.107"|del(.runtimes))' global.json > global.json~
    mv global.json~ global.json
    patchShebangs *.sh
    HOME=$(pwd)/fake-home \
    DotNetBuildFromSource=true \
      ./build.sh /p:ArcadeBuildTarball=true /p:TarballDir=\"$out\" /p:OfficialBuildId=20220101.1
  '';

  mkSdk = bootstrap-sdk: clangStdenv.mkDerivation (finalAttrs: rec {
    name = "dotnet-sdk";
    version = "6.0.108";

    src = dotnet-sdk-src;

    nativeBuildInputs = [
      curl
      git # used for patching
      python3
      cmake
      pkg-config
    ];

    buildInputs = [
      llvm
      zlib
      icu
    ] ++ lib.optional stdenv.isLinux lttng-ust_2_12;

    postUnpack = ''
      # The build process tries to overwrite some things in the sdk (e.g.
      # SourceBuild.MSBuildSdkResolver.dll), so it needs to be mutable.
      cp -Tr ${bootstrap-sdk} $sourceRoot/.dotnet
      chmod -R +w $sourceRoot/.dotnet
      # Sets all timestamps to Jan 1 1980, the earliest mtime zips support.
      find "$sourceRoot" -exec touch -t 198001010000.00 {} +
    '';

    postPatch = ''
      # If this exists, --with-packages doesn't work.
      rm -fr packages/archive
      # these get copied around, but the empty objects/ directories get skipped,
      # causing the repo to be invalid
      for x in src/source-build/.git src/source-build/.git/modules/src/*; do touch $x/objects/.keep; done
      patchShebangs $(find -name \*.sh -type f -executable)
      # I'm not sure why this is required, but these files seem to use the wrong
      # property name.
      sed -i 's:\bVersionBase\b:VersionPrefix:g' \
        src/clicommandlineparser/eng/Versions.props \
        src/xliff-tasks/eng/Versions.props
      # stop looking in /etc/os-release for distro rid
      substituteInPlace \
        ./src/runtime/eng/native/init-distro-rid.sh \
        --replace '[ -e "''${rootfsDir}/etc/os-release" ]' 'false'
      substituteInPlace \
        src/runtime/src/libraries/Native/Unix/System.Net.Security.Native/pal_gssapi.c \
        --replace '"libgssapi_krb5.so.2"' '"${libkrb5}/lib/libgssapi_krb5.so.2"'
      substituteInPlace \
        src/runtime/src/libraries/Native/Unix/System.Globalization.Native/pal_icushim.c \
        --replace '"libicui18n.so"' '"${icu}/lib/libicui18n.so"' \
        --replace '"libicuuc.so"' '"${icu}/lib/libicuuc.so"' \
        --replace 'libicuucName[64]' 'libicuucName[256]' \
        --replace 'libicui18nName[64]' 'libicui18nName[256]'
    '';

    dontUseCmakeConfigure = true;

    # https://github.com/NixOS/nixpkgs/issues/38991
    # bash: warning: setlocale: LC_ALL: cannot change locale (en_US.UTF-8)
    LOCALE_ARCHIVE = lib.optionalString stdenv.isLinux
        "${glibcLocales}/lib/locale/locale-archive";

    buildFlags = [
      "--clean-while-building"
      "--with-sdk" ".dotnet"
      "--with-packages" bootstrap-sdk.packages
    ];

    buildPhase = ''
      runHook preBuild

      # If version is set, it overrides the version of certain packages, such as
      # newtonsoft-json, which breaks things that depend on it.

      # CLR_CC/CXX need to be set to stop the build system from using clang-11,
      # which is unwrapped

      # icu needs to be in the LD path so the newly built libraries will work
      # before being patched in fixup

      # Nuget needs a writable home dir.

      version= \
      CLR_CC=$(command -v clang) \
      CLR_CXX=$(command -v clang++) \
      HOME=$(pwd)/fake-home \
      DOTNET_RUNTIME_ID=${dotnetCorePackages.systemToDotnetRid stdenv.targetPlatform.system} \
        ./build.sh $buildFlags

      runHook postBuild
    '';

    outputs = [ "out" "packages" ];

    installPhase = ''
      runHook preInstall
      mkdir "$out"
      tar -C "$out" -xzf "$(pwd)"/artifacts/x64/Release/dotnet-sdk-${version}-linux-x64.tar.gz
      mkdir "$out"/bin
      ln -s "$out"/dotnet "$out"/bin/dotnet
      mkdir "$packages"
      tar -C "$packages" -xzf "$(pwd)"/artifacts/x64/Release/Private.SourceBuilt.Artifacts.${version}.tar.gz
      runHook postInstall
    '';

    # TODO
    # passthru.updateScript = ./update.sh;

    meta = with lib; {
      description = "Core functionality needed to create .NET Core projects, that is shared between Visual Studio and CLI";
      homepage = "https://dotnet.github.io/";
      license = licenses.mit;
      maintainers = with maintainers; [ corngood ];
      mainProgram = "dotnet";
      platforms = builtins.attrNames rids;
    };
  } // import ./common.nix {
    inherit stdenv writeText testers runCommand;
    inherit (finalAttrs) finalPackage;
  });

  stage0 = mkSdk bootstrap-sdk;
  stage1 = mkSdk stage0;

# TODO: switch to stage1?
in stage0
