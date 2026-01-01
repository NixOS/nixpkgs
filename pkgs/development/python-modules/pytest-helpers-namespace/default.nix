{
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  isPy27,
  lib,
  setuptools,
  setuptools-declarative-requirements,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pytest-helpers-namespace";
  version = "2021.12.29";
  format = "setuptools";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "792038247e0021beb966a7ea6e3a70ff5fcfba77eb72c6ec8fd6287af871c35b";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-declarative-requirements
    setuptools-scm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_helpers_namespace" ];

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/saltstack/pytest-helpers-namespace";
    description = "PyTest Helpers Namespace";
    license = lib.licenses.asl20;
=======
  meta = with lib; {
    homepage = "https://github.com/saltstack/pytest-helpers-namespace";
    description = "PyTest Helpers Namespace";
    license = licenses.asl20;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
