{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pytest-asyncio
, pythonOlder
}:

buildPythonPackage rec {
  pname = "sanic-routing";
  version = "22.8.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sanic-org";
    repo = "sanic-routing";
    rev = "refs/tags/v${version}";
    hash = "sha256-2T6WY0nzvr8Q9lBoStzmX7m7Ct35lcG53OSLcqxkEcY=";
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "sanic_routing"
  ];

  meta = with lib; {
    description = "Core routing component for the Sanic web framework";
    homepage = "https://github.com/sanic-org/sanic-routing";
    changelog = "https://github.com/sanic-org/sanic-routing/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ AluisioASG ];
  };
}
