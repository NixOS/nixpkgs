{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "process-tests";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dd731906f8fc0b803ffe2dd5c5e4b103ec24b1f962a7b835d9533d7e9b2ca36c";
  };

  # No tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Tools for testing processes";
    license = licenses.bsd2;
    homepage = https://github.com/ionelmc/python-process-tests;
  };

}
