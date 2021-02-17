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
  version = "1.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cacb9df31c9680ec5f95553976c4da484d407e85e41c83cb812aa014f0eddc50";
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
    maintainers = with maintainers; [ nand0p ];
  };

}
