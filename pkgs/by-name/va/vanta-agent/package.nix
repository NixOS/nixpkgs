{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
}:
let
  version = "2.9.0";
in
stdenv.mkDerivation {
  pname = "vanta-agent";
  inherit version;
  src = fetchurl {
    url = "https://vanta-agent-repo.s3.amazonaws.com/targets/versions/${version}/vanta-amd64.deb";
    hash = "sha256-oTiILQNXcO3rPmXdLhueQw+h2psqMUcw+UmXaU70UYs=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];

  unpackPhase = ''
    runHook preUnpack

    dpkg-deb -x $src .

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    # binaries + certificate
    mkdir -p $out
    cp -r var $out/

    # systemd service
    mkdir -p $out/lib
    cp -r usr/lib/systemd $out/lib

    # mainProgram
    mkdir -p $out/bin
    cp -r var/vanta/vanta-cli $out/bin/

    runHook postInstall
  '';

  meta = {
    description = "Vanta Agent";
    homepage = "https://vanta.com";
    maintainers = with lib.maintainers; [ matdibu ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "vanta-cli";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
