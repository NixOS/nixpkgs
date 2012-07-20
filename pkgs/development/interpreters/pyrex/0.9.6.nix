{ stdenv, fetchurl, pythonPackages }:

let version = "0.9.6.4"; in

pythonPackages.buildPythonPackage rec {
  name = "pyrex-${version}";

  src = fetchurl {
    url = "http://www.cosc.canterbury.ac.nz/greg.ewing/python/Pyrex/oldtar/Pyrex-${version}.tar.gz";
    sha256 = "18pd9f8al3l6i27cc0ddhgg7hxf28lnfs75x4a8jzscydxgiq5a8";
  };

  doCheck = false;

  meta = {
    homepage = http://www.cosc.canterbury.ac.nz/greg.ewing/python/Pyrex/;
    description = "A language for writing Python extension modules";
  };
}
