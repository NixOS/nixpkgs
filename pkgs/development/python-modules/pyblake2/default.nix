{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pyblake2";
  version = "1.1.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3a850036bf42053c74bfc52c063323ca78e40ba1f326b01777da5750a143631a";
  };

  # requires setting up sphinx doctest
  doCheck = false;

  meta = {
    description = "BLAKE2 hash function extension module";
    license = lib.licenses.publicDomain;
    homepage = https://github.com/dchest/pyblake2;
  };
}