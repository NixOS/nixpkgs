# This file was generated and will be overwritten by ./generate.sh

{
  stdenv,
  lib,
  fetchurl,
}:

stdenv.mkDerivation {
  pname = "python310-docs-texinfo";
  version = "3.10.7";

  src = fetchurl {
    url = "http://www.python.org/ftp/python/doc/3.10.7/python-3.10.7-docs-texinfo.tar.bz2";
    sha256 = "0p0fifi84ijz4ng6krw7c1x965jhgysprkijblmlnax7x9rmqrdf";
  };
  installPhase = ''
    mkdir -p $out/share/info
    cp ./python.info $out/share/info
  '';
  meta = {
    maintainers = [ ];
  };
}
