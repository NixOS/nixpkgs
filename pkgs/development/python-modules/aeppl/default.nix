{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  aesara,
  numpy,
  scipy,
  numdifftools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "aeppl";
  version = "0.1.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "aesara-devs";
    repo = "aeppl";
    rev = "refs/tags/v${version}";
    hash = "sha256-mqBbXwWJwQA2wSHuEdBeXQMfTIcgwYEjpq8AVmOjmHM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aesara
    numpy
    scipy
  ];

  nativeCheckInputs = [
    numdifftools
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  pythonImportsCheck = [ "aeppl" ];

  disabledTests = [
    # Compute issue
    "test_initial_values"
  ];

  pytestFlagsArray = [
    # `numpy.distutils` is deprecated since NumPy 1.23.0, as a result of the deprecation of `distutils` itself.
    # It will be removed for Python >= 3.12. For older Python versions it will remain present.
    "-Wignore::DeprecationWarning"
    # Blas cannot be found, allow fallback to the numpy slower implementation
    "-Wignore::UserWarning"
  ];

  meta = with lib; {
    description = "Library for an Aesara-based PPL";
    homepage = "https://github.com/aesara-devs/aeppl";
    changelog = "https://github.com/aesara-devs/aeppl/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
