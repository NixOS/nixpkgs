# This file was generated and will be overwritten by ./generate.sh

{ stdenv, fetchurl }:

stdenv.mkDerivation {
  pname = "python312-docs-pdf-letter";
  version = "3.12.5";

  src = fetchurl {
    url = "http://www.python.org/ftp/python/doc/3.12.5/python-3.12.5-docs-pdf-letter.tar.bz2";
    sha256 = "1xp7zqjc6nkb38panc9jykhjsdvsznasfqgpzk0fn6mdq6mibvsd";
  };
  installPhase = ''
    mkdir -p $out/share/doc/python312
    cp -R ./ $out/share/doc/python312/pdf-letter
  '';
  meta = {
    maintainers = [ ];
  };
}
