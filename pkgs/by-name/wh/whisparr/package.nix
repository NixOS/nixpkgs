{
  lib,
  stdenv,

  curl,
  dotnet-runtime,
  fetchurl,
  icu,
  libmediainfo,
  makeWrapper,
  mono,
  openssl,
  sqlite,
  zlib,

  nixosTests,
}:

let
  os = if stdenv.hostPlatform.isDarwin then "osx" else "linux";
  system = stdenv.hostPlatform.system;
  arch =
    {
      aarch64-darwin = "arm64";
      aarch64-linux = "arm64";
      x86_64-darwin = "x64";
      x86_64-linux = "x64";
    }
    ."${system}" or (throw "Unsupported system: ${system}");
  hash =
    {
      arm64-linux-hash = "sha256-AGERhD8EiTkaXw7GWVaWPFVuQkclSarNOGMgs+6zxfI=";
      arm64-osx-hash = "sha256-AUZoAAEmgrb1A7OKLc7QOliGTgctD9MuM9rqNWQ3ySM=";
      x64-linux-hash = "sha256-ZRbV1nxAIiHUL8DzmlAJRcFOnl5t8+ur3zXhw29mUfk=";
      x64-osx-hash = "sha256-WfR0x89wQNAiLYX1Dg5AsEuiqHSX9IhhxEOoVuPjRH8=";
    }
    ."${arch}-${os}-hash";
in
stdenv.mkDerivation rec {
  pname = "whisparr";
  version = "2.0.0.1282";

  src = fetchurl {
    name = "${pname}-${arch}-${os}-${version}.tar.gz";
    url = "https://whisparr.servarr.com/v1/update/nightly/updatefile?runtime=netcore&version=${version}&arch=${arch}&os=${os}";
    inherit hash;
  };

  nativeBuildInputs = [ makeWrapper ];

  runtimeLibs = lib.makeLibraryPath [
    curl
    icu
    libmediainfo
    mono
    openssl
    sqlite
    zlib
  ];

  installPhase = ''
    runHook preInstall

    rm -rf "Whisparr.Update"

    mkdir -p $out/{bin,share/${pname}-${version}}
    cp -r * $out/share/${pname}-${version}/

    makeWrapper "${dotnet-runtime}/bin/dotnet" $out/bin/Whisparr \
      --add-flags "$out/share/${pname}-${version}/Whisparr.dll" \
      --prefix LD_LIBRARY_PATH : ${runtimeLibs}

    runHook postInstall
  '';

  passthru = {
    updateScript = ./update.sh;
    tests.smoke-test = nixosTests.whisparr;
  };

  meta = {
    description = "Adult movie collection manager for Usenet and BitTorrent users";
    homepage = "https://wiki.servarr.com/en/whisparr";
    changelog = "https://whisparr.servarr.com/v1/update/nightly/changes";
    license = lib.licenses.gpl3Only;
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "Whisparr";
    maintainers = [ ];
  };
}
