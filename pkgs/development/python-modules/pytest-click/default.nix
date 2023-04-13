{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytest
, click
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytest-click";
  version = "1.1.0";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "Stranger6667";
    repo = "pytest-click";
    rev = "v${version}";
    hash = "sha256-A/RF+SgPu2yYF3eHEFiZwKJW2VwQ185Ln6S3wn2cS0k=";
  };

  buildInputs = [ pytest ];

  propagatedBuildInputs = [
    click
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "pytest plugin for click";
    homepage = "https://github.com/Stranger6667/pytest-click";
    changelog = "https://github.com/Stranger6667/pytest-click/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc ];
  };
}
