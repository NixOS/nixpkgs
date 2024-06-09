{
  lib,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  justbackoff,
  pythonOlder,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "nessclient";
  version = "1.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "nickw444";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-UqHXKfS4zF1YhFbNKSVESmsxD0CYJKOmjMOE3blGdI8=";
  };

  propagatedBuildInputs = [
    justbackoff
    click
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "nessclient" ];

  meta = with lib; {
    description = "Python implementation/abstraction of the Ness D8x/D16x Serial Interface ASCII protocol";
    mainProgram = "ness-cli";
    homepage = "https://github.com/nickw444/nessclient";
    changelog = "https://github.com/nickw444/nessclient/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
