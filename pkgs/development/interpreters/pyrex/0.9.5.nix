{ stdenv, fetchurl, pythonPackages }:

let version = "0.9.5.1.1"; in

pythonPackages.buildPythonPackage rec {
  name = "pyrex-${version}";

  src = fetchurl {
    url = "http://www.cosc.canterbury.ac.nz/greg.ewing/python/Pyrex/oldtar/Pyrex-${version}.tar.gz";
    sha256 = "0lxxvn4mjfb83swcbqb5908q4iy53w4ip5i0f9angm2va1jyhd3z";
  };

  doCheck = false;

  meta = {
    homepage = http://www.cosc.canterbury.ac.nz/greg.ewing/python/Pyrex/;
    description = "A language for writing Python extension modules";
  };
}
