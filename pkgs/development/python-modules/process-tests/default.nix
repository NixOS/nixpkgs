{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "process-tests";
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f43f3540edd333bdc5d8741218e173b1dfdbce5b0a40066d75248911e5340a06";
  };

  # No tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Tools for testing processes";
    license = licenses.bsd2;
    homepage = https://github.com/ionelmc/python-process-tests;
  };

}
