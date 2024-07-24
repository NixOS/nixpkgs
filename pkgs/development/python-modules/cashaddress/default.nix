{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pythonOlder,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "cashaddress";
  version = "1.0.6-unstable-2015-05-19";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "oskyk";
    repo = "cashaddress";
    rev = "0ca44cff6bd3e63a67b494296c0d1eeaf6cc120d";
    hash = "sha256-4izWD2KZqy1F7CAgdbe1fpjMlMZC0clrkHKS9IIQuoc=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "cashaddress" ];

  meta = with lib; {
    description = "Python tool for convert bitcoin cash legacy addresses";
    homepage = "https://github.com/oskyk/cashaddress";
    changelog = "https://github.com/oskyk/cashaddress/releases/tag/${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
