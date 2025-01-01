{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  jinja2,
  pytest,
  rich,
  pythonOlder,
  syrupy,
  textual,
}:

buildPythonPackage rec {
  pname = "pytest-textual-snapshot";
  version = "1.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Textualize";
    repo = "pytest-textual-snapshot";
    rev = "refs/tags/v${version}";
    hash = "sha256-C8vL2kLOvVcDlTtNiG/pf7PwHzb/F0sWdkEcLvdGrd8=";
  };

  nativeBuildInputs = [ poetry-core ];

  buildInputs = [ pytest ];

  propagatedBuildInputs = [
    jinja2
    rich
    syrupy
    textual
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "pytest_textual_snapshot" ];

  meta = with lib; {
    description = "Snapshot testing for Textual applications";
    homepage = "https://github.com/Textualize/pytest-textual-snapshot";
    changelog = "https://github.com/Textualize/pytest-textual-snapshot/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
