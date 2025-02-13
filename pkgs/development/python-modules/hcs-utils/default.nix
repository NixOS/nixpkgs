{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  six,
  poetry-core,
  fetchFromGitLab,
}:

buildPythonPackage rec {
  pname = "hcs-utils";
  version = "2.1.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitLab {
    owner = "hcs";
    repo = "hcs_utils";
    rev = "77668de42895dedb6b4baddf4207f331776de897"; # No tags for 2.1
    hash = "sha256-T0a2lYi3umRZQInEsxnLf5p6+IxkUmGJhgW8l2ESDd0=";
  };

  build-system = [
    setuptools
    poetry-core
  ];

  dependencies = [
    six
  ];

  disabledTests = [
    "test_expand" # It depends on FHS
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Library collecting some useful snippets";
    homepage = "https://gitlab.com/hcs/hcs_utils";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ lovek323 ];
  };
}
