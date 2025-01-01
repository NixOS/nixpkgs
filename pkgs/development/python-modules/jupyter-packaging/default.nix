{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,
  deprecation,
  hatchling,
  pythonOlder,
  packaging,
  pytestCheckHook,
  pytest-timeout,
  setuptools,
  tomlkit,
}:

buildPythonPackage rec {
  pname = "jupyter-packaging";
  version = "0.12.3";
  disabled = pythonOlder "3.7";
  format = "pyproject";

  src = fetchPypi {
    pname = "jupyter_packaging";
    inherit version;
    hash = "sha256-nZsrY7l//WeovFORwypCG8QVsmSjLJnk2NjdMdqunPQ=";
  };

  patches = [
    (fetchpatch {
      name = "setuptools-68-test-compatibility.patch";
      url = "https://github.com/jupyter/jupyter-packaging/commit/e963fb27aa3b58cd70c5ca61ebe68c222d803b7e.patch";
      hash = "sha256-NlO07wBCutAJ1DgoT+rQFkuC9Y+DyF1YFlTwWpwsJzo=";
    })
  ];

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [
    deprecation
    packaging
    setuptools
    tomlkit
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-timeout
  ];

  pytestFlagsArray = [ "-Wignore::DeprecationWarning" ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTests = [
    # disable tests depending on network connection
    "test_develop"
    "test_install"
    # Avoid unmainted "mocker" fixture library, and calls to dependent "build" module
    "test_build"
    "test_npm_build"
    "test_create_cmdclass"
    "test_ensure_with_skip_npm"
  ];

  pythonImportsCheck = [ "jupyter_packaging" ];

  meta = with lib; {
    description = "Jupyter Packaging Utilities";
    homepage = "https://github.com/jupyter/jupyter-packaging";
    license = licenses.bsd3;
  };
}
