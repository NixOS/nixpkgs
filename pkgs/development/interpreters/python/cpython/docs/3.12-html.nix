# This file was generated and will be overwritten by ./generate.sh

{ stdenv, fetchurl }:

stdenv.mkDerivation {
  pname = "python312-docs-html";
  version = "3.12.5";

  src = fetchurl {
    url = "http://www.python.org/ftp/python/doc/3.12.5/python-3.12.5-docs-html.tar.bz2";
    sha256 = "1irn7rbzzdf7g91w43k38mbjwqrmx37gvjf5q7rqba9gjzjz967n";
  };
  installPhase = ''
    mkdir -p $out/share/doc/python312
    cp -R ./ $out/share/doc/python312/html
  '';
  meta = {
    maintainers = [ ];
  };
}
