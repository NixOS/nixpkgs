{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "argparse-dataclass";
  version = "2.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mivade";
    repo = "argparse_dataclass";
    tag = version;
    hash = "sha256-ASdP6LOEeTszyppYV6vRQX8BKOHYUimI36tMSZTQfTk=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "argparse_dataclass" ];

  meta = with lib; {
    description = "Declarative CLIs with argparse and dataclasses";
    homepage = "https://github.com/mivade/argparse_dataclass";
    changelog = "https://github.com/mivade/argparse_dataclass/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ tm-drtina ];
  };
}
