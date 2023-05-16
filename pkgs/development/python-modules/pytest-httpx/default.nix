{ lib
, buildPythonPackage
, fetchFromGitHub
, httpx
, pytest
, pytest-asyncio
, pytestCheckHook
, pythonOlder
<<<<<<< HEAD
, pythonRelaxDepsHook
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "pytest-httpx";
<<<<<<< HEAD
  version = "0.22.0";
=======
  version = "0.21.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Colin-b";
    repo = "pytest_httpx";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-J5Y5G3/8d9hAtDFqweqA73amnXUpPbmb0uTrCslpl9k=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

=======
    hash = "sha256-+jOPbEul/mkZbaR6ZqwLTgVtemi18vOYgqJcgv6JSII=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    httpx
  ];

<<<<<<< HEAD
  pythonRelaxDeps = [
    "httpx"
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pytest_httpx"
  ];

  meta = with lib; {
    description = "Send responses to httpx";
    homepage = "https://github.com/Colin-b/pytest_httpx";
    changelog = "https://github.com/Colin-b/pytest_httpx/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
