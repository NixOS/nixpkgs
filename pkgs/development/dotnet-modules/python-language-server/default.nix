{ lib, stdenv
, fetchFromGitHub
, fetchurl
, makeWrapper
, dotnet-sdk_3
, openssl
, icu
, patchelf
, Nuget
}:

let deps = import ./deps.nix { inherit fetchurl; };
    version = "2021-05-20";

    # Build the nuget source needed for the later build all by itself
    # since it's a time-consuming step that only depends on ./deps.nix.
    # This makes it easier to experiment with the main build.
    nugetSource = stdenv.mkDerivation {
      pname = "python-language-server-nuget-deps";
      inherit version;

      dontUnpack = true;

      nativeBuildInputs = [ Nuget ];

      buildPhase = ''
        export HOME=$(mktemp -d)

        mkdir -p $out/lib

        # disable default-source so nuget does not try to download from online-repo
        nuget sources Disable -Name "nuget.org"
        # add all dependencies to the source
        for package in ${toString deps}; do
          nuget add $package -Source $out/lib
        done
      '';

      dontInstall = true;
    };

in

stdenv.mkDerivation {
  pname = "python-language-server";
  inherit version;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "python-language-server";
    rev = "86825796eae15d4d46919bc6e32f1197196ba1b3";
    sha256 = "sha256-izDE7Oil9g47Jf3eHPtW5coNixF71t9i0oYSuelakCo=";
  };

  buildInputs = [dotnet-sdk_3 openssl icu];

  nativeBuildInputs = [
    Nuget
    makeWrapper
    patchelf
  ];

  buildPhase = ''
    runHook preBuild

    mkdir home
    export HOME=$(mktemp -d)
    export DOTNET_CLI_TELEMETRY_OPTOUT=1
    export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1

    pushd src
    nuget sources Disable -Name "nuget.org"
    dotnet restore --source ${nugetSource}/lib -r linux-x64
    popd

    pushd src/LanguageServer/Impl
    dotnet publish --no-restore -c Release -r linux-x64
    popd

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r output/bin/Release/linux-x64/publish $out/lib

    mkdir $out/bin
    makeWrapper $out/lib/Microsoft.Python.LanguageServer $out/bin/python-language-server

    runHook postInstall
  '';

  postFixup = ''
    patchelf --set-rpath ${icu}/lib $out/lib/System.Globalization.Native.so
    patchelf --set-rpath ${openssl.out}/lib $out/lib/System.Security.Cryptography.Native.OpenSsl.so
  '';

  # If we don't disable stripping, the executable fails to start with an error about being unable
  # to find some of the packaged DLLs.
  dontStrip = true;

  meta = with lib; {
    description = "Microsoft Language Server for Python";
    homepage = "https://github.com/microsoft/python-language-server";
    license = licenses.asl20;
    maintainers = with maintainers; [ thomasjm ];
    platforms = [ "x86_64-linux" ];
  };
}
