{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "cpe";
  version = "1.2.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "nilp0inter";
    repo = "cpe";
    rev = "refs/tags/v${version}";
    hash = "sha256-1hTOMbsL1089/yPZbAIs5OgjtEzCBlFv2hGi+u4hV/k=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "cpe" ];

  disabledTests = [
    # Tests are outdated
    "testfile_cpelang2"
    "test_incompatible_versions"
    "test_equals"
  ];

  meta = {
    description = "Common platform enumeration for python";
    homepage = "https://github.com/nilp0inter/cpe";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ tochiaha ];
  };
}
