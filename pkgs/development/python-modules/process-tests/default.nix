{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "process-tests";
  version = "2.1.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a3747ad947bdfc93e5c986bdb17a6d718f3f26e8577a0807a00962f29e26deba";
  };

  # No tests
  doCheck = false;

  meta = with lib; {
    description = "Tools for testing processes";
    license = licenses.bsd2;
    homepage = "https://github.com/ionelmc/python-process-tests";
  };

}
