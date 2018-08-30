{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pyblake2";
  version = "1.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5ccc7eb02edb82fafb8adbb90746af71460fbc29aa0f822526fc976dff83e93f";
  };

  # requires setting up sphinx doctest
  doCheck = false;

  meta = {
    description = "BLAKE2 hash function extension module";
    license = lib.licenses.publicDomain;
    homepage = https://github.com/dchest/pyblake2;
  };
}