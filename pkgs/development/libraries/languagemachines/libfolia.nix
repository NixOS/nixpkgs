{ stdenv, fetchurl
, automake, autoconf, libtool, pkgconfig, autoconf-archive
, libxml2, icu
, languageMachines }:

let
  release = builtins.fromJSON (builtins.readFile ./release-info/LanguageMachines-libfolia.json);
in

stdenv.mkDerivation {
  name = "libfolia";
  version = release.version;
  src = fetchurl { inherit (release) url sha256;
                   name = "libfolia-${release.version}.tar.gz"; };
  buildInputs = [ automake autoconf libtool pkgconfig autoconf-archive libxml2 icu languageMachines.ticcutils ];
  preConfigure = "sh bootstrap.sh";

  meta = with stdenv.lib; {
    description = "A C++ API for FoLiA documents; an XML-based linguistic annotation format.";
    homepage    = https://proycon.github.io/folia/;
    license     = licenses.gpl3;
    platforms   = platforms.all;
    maintainers = with maintainers; [ roberth ];

    longDescription = ''
      A high-level C++ API to read, manipulate, and create FoLiA documents. FoLiA is an XML-based annotation format, suitable for the representation of linguistically annotated language resources. FoLiA’s intended use is as a format for storing and/or exchanging language resources, including corpora.
    '';
  };

}
