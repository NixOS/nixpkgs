{ stdenv, fetchurl, python2Packages }:

let version = "0.9.5.1.1"; in

python2Packages.buildPythonPackage rec {
  name = "pyrex-${version}";

  src = fetchurl {
    url = "https://www.cosc.canterbury.ac.nz/greg.ewing/python/Pyrex/oldtar/Pyrex-${version}.tar.gz";
    sha256 = "0lxxvn4mjfb83swcbqb5908q4iy53w4ip5i0f9angm2va1jyhd3z";
  };

  doCheck = false;

  meta = {
    homepage = http://www.cosc.canterbury.ac.nz/greg.ewing/python/Pyrex/;
    description = "A language for writing Python extension modules";
    license = stdenv.lib.licenses.asl20;
  };
}
