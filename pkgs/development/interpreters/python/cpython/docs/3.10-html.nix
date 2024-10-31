# This file was generated and will be overwritten by ./generate.sh

{ stdenv, lib, fetchurl }:

stdenv.mkDerivation {
  pname = "python310-docs-html";
  version = "3.10.7";

  src = fetchurl {
    url = "http://www.python.org/ftp/python/doc/3.10.7/python-3.10.7-docs-html.tar.bz2";
    sha256 = "0j86z1vmaghzj5i4frvzyfb9qwsmm09g4f4ssx5w27cm30b8k0v1";
  };
  installPhase = ''
    mkdir -p $out/share/doc/python310
    cp -R ./ $out/share/doc/python310/html
  '';
  meta = {
    maintainers = [ ];
  };
}
