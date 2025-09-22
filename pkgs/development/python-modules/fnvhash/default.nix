{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "fnvhash";
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "znerol";
    repo = "py-fnvhash";
    tag = "v${version}";
    hash = "sha256-vAflKSvi0PD5r1q6GCTt6a4vTCsdBIebecRCKbbBphE=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "fnvhash" ];

  meta = with lib; {
    changelog = "https://github.com/znerol/py-fnvhash/releases/tag/${src.tag}";
    description = "Python FNV hash implementation";
    homepage = "https://github.com/znerol/py-fnvhash";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
