# This file was generated and will be overwritten by ./generate.sh

{ stdenv, lib, fetchurl }:

stdenv.mkDerivation {
  pname = "python27-docs-text";
  version = "2.7.18";

  src = fetchurl {
    url = "http://www.python.org/ftp/python/doc/2.7.18/python-2.7.18-docs-text.tar.bz2";
    sha256 = "1wj7mxs52kp5lmn5mvv574sygkfnk00kbz9ya9c03yfq5dd5nvy8";
  };
  installPhase = ''
    mkdir -p $out/share/doc/python27
    cp -R ./ $out/share/doc/python27/text
  '';
  meta = {
    maintainers = [ ];
  };
}
