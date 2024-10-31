{
  lib,
  buildPythonPackage,
  dissect-cstruct,
  dissect-util,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "dissect-vmfs";
  version = "3.9";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.vmfs";
    rev = "refs/tags/${version}";
    hash = "sha256-855Rqz4WuTwopJo1yT8zsSvods3p+7EoB1sAXu3U5QU=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    dissect-cstruct
    dissect-util
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dissect.vmfs" ];

  meta = with lib; {
    description = "Dissect module implementing a parser for the VMFS file system";
    homepage = "https://github.com/fox-it/dissect.vmfs";
    changelog = "https://github.com/fox-it/dissect.vmfs/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
