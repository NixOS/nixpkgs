{ buildPythonPackage
, fetchPypi
, pytestCheckHook
, isPy27
, lib
, setuptools
, setuptools-declarative-requirements
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pytest-helpers-namespace";
  version = "2021.3.24";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0pyj2d45zagmzlajzqdnkw5yz8k49pkihbydsqkzm413qnkzb38q";
  };

  nativeBuildInputs = [ setuptools setuptools-declarative-requirements setuptools-scm ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_helpers_namespace" ];

  meta = with lib; {
    homepage = "https://github.com/saltstack/pytest-helpers-namespace";
    description = "PyTest Helpers Namespace";
    license = licenses.asl20;
    maintainers = [ maintainers.kiwi ];
  };
}
