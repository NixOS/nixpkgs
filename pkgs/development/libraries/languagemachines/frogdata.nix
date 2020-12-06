{ stdenv, fetchurl
, automake, autoconf, libtool, pkgconfig, autoconf-archive
}:

let
  release = builtins.fromJSON (builtins.readFile ./release-info/LanguageMachines-frogdata.json);
in

stdenv.mkDerivation {
  name = "frogdata-${release.version}";
  version = release.version;
  src = fetchurl { inherit (release) url sha256;
                   name = "frogdata-${release.version}.tar.gz"; };
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ automake autoconf libtool autoconf-archive
                ];

  preConfigure = ''
    sh bootstrap.sh
  '';

  meta = with stdenv.lib; {
    description = "Data for Frog, a Tagger-Lemmatizer-Morphological-Analyzer-Dependency-Parser for Dutch";
    homepage    = "https://languagemachines.github.io/frog";
    license     = licenses.gpl3;
    platforms   = platforms.all;
    maintainers = with maintainers; [ roberth ];
  };

}
