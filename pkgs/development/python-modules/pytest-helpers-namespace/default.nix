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
  version = "2021.12.29";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "792038247e0021beb966a7ea6e3a70ff5fcfba77eb72c6ec8fd6287af871c35b";
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
