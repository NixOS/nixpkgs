{ lib
, buildPythonPackage
, isPyPy
, fetchPypi
, pytestCheckHook
, setuptools-scm
, apipkg
}:

buildPythonPackage rec {
  pname = "execnet";
  version = "1.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8f694f3ba9cc92cab508b152dcfe322153975c29bda272e2fd7f3f00f36e47c5";
  };

  checkInputs = [ pytestCheckHook ];
  nativeBuildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [ apipkg ];

  # remove vbox tests
  postPatch = ''
    rm -v testing/test_termination.py
    rm -v testing/test_channel.py
    rm -v testing/test_xspec.py
    rm -v testing/test_gateway.py
    ${lib.optionalString isPyPy "rm -v testing/test_multi.py"}
  '';

  pythonImportsCheck = [ "execnet" ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Distributed Python deployment and communication";
    license = licenses.mit;
    homepage = "https://execnet.readthedocs.io/";
    maintainers = with maintainers; [ ];
  };

}
