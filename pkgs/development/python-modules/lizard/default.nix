{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, mock
, jinja2
}:

buildPythonPackage rec {
  pname = "lizard";
  version = "1.17.10";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "terryyin";
    repo = "lizard";
    rev = version;
    hash = "sha256-4jq6gXpI1hFtX7ka2c/qQ+S6vZCThKOGhQwJ2FOYItY=";
  };

  propagatedBuildInputs = [ jinja2 ];

  nativeCheckInputs = [
    pytestCheckHook
    mock
  ];

  pythonImportsCheck = [
    "lizard"
  ];

  meta = with lib; {
    description = "Code analyzer without caring the C/C++ header files";
    homepage = "http://www.lizard.ws";
    license = licenses.mit;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}

