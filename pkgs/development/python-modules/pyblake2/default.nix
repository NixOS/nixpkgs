{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pyblake2";
  version = "0.9.3";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "626448e1fe1cc01d2197118954bec9f158378577e12686d5b01979f7f0fa2212";
  };

  # requires setting up sphinx doctest
  doCheck = false;

  meta = {
    description = "BLAKE2 hash function extension module";
    license = lib.licenses.publicDomain;
    homepage = https://github.com/dchest/pyblake2;
  };
}