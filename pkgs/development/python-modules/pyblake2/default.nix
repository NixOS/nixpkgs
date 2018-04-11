{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pyblake2";
  version = "1.1.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8ec8e9087d13c99b354ab6d8b4cadb1758633db5946ff95a6bc7ac538b6d7b3d";
  };

  # requires setting up sphinx doctest
  doCheck = false;

  meta = {
    description = "BLAKE2 hash function extension module";
    license = lib.licenses.publicDomain;
    homepage = https://github.com/dchest/pyblake2;
  };
}