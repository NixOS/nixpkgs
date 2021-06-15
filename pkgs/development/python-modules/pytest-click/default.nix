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
  version = "1.0.2";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "Stranger6667";
    repo = "pytest-click";
    rev = "v${version}";
    sha256 = "197nvlqlyfrqpy5lrkmfh1ywpr6j9zipxl9d7syg2a2n7jz3a8rj";
  };

  buildInputs = [ pytest ];

  propagatedBuildInputs = [
    click
  ];

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "pytest plugin for click";
    homepage = "https://github.com/Stranger6667/pytest-click";
    changelog = "https://github.com/Stranger6667/pytest-click/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc ];
  };
}
