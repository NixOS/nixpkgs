{
  lib,
  stdenv,
  fetchurl,
  automake,
  autoconf,
  libtool,
  pkg-config,
  autoconf-archive,
}:

let
  release = lib.importJSON ./release-info/LanguageMachines-frogdata.json;
in

stdenv.mkDerivation {
  pname = "frogdata";
  version = release.version;
  src = fetchurl {
    inherit (release) url sha256;
    name = "frogdata-${release.version}.tar.gz";
  };
  nativeBuildInputs = [
    pkg-config
    automake
    autoconf
  ];
  buildInputs = [
    libtool
    autoconf-archive
  ];

  preConfigure = ''
    sh bootstrap.sh
  '';

  meta = with lib; {
    description = "Data for Frog, a Tagger-Lemmatizer-Morphological-Analyzer-Dependency-Parser for Dutch";
    homepage = "https://languagemachines.github.io/frog";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ roberth ];
  };

}
