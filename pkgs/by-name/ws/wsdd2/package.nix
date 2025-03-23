{
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  lib,
}:
stdenv.mkDerivation rec {
  pname = "wsdd2";
  version = "1.8.7";
  src = fetchFromGitHub {
    owner = "Netgear";
    repo = "wsdd2";
    rev = "${version}";
    hash = "sha256-K0pGqcWzTgJGdQOIvrkXUPosgaOSL1lm81MEevK8YXk=";
  };
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ ];
  buildPhase = ''
    make
  '';
  installPhase = ''
    mkdir -p $out/bin
    install -m755 wsdd2 $out/bin/wsdd2
  '';
  meta = with lib; {
    description = "WSD/LLMNR Discovery/Name Service Daemon";
    homepage = "https://github.com/Netgear/wsdd2";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
