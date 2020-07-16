{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "cppy";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4eda6f1952054a270f32dc11df7c5e24b259a09fddf7bfaa5f33df9fb4a29642";
  };

  # Headers-only library, no tests
  doCheck = false;

  # Not supported
  disabled = !isPy3k;

  meta = {
    description = "C++ headers for C extension development";
    homepage = "https://github.com/nucleic/cppy";
    license = lib.licenses.bsd3;
  };
}