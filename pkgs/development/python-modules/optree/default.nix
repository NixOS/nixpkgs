{
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  lib,
  cmake,
  setuptools,
  typing-extensions,
  pybind11,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "optree";
  version = "0.12.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "metaopt";
    repo = "optree";
    rev = "refs/tags/v${version}";
    hash = "sha256-4GvB9Z7qnEjsUSl+x5wd8czV80F50MwJdlNdylUU0zY=";
  };

  dontUseCmakeConfigure = true;

  propagatedBuildInputs = [ typing-extensions ];
  nativeBuildInputs = [
    setuptools
    pybind11
    cmake
  ];

  nativeCheckInputs = [ pytestCheckHook ];
  # prevent import failures from pytest
  preCheck = ''
    rm -r optree
  '';
  disabledTests = [
    # Fails because the 'test_treespec' module can't be found
    "test_treespec_pickle_missing_registration"
  ];
  pythonImportsCheck = [ "optree" ];

  meta = {
    description = "Optimized PyTree Utilities";
    homepage = "https://github.com/metaopt/optree";
    changelog = "https://github.com/metaopt/optree/releases";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
}
