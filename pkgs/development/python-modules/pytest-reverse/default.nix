{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, pytest
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pytest-reverse";
  version = "1.7.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "adamchainz";
    repo = "pytest-reverse";
    rev = version;
    hash = "sha256-r0aSbUgArHQkpaXUvMT6oyOxEliQRtSGuDt4IILzhH4=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  buildInputs = [ pytest ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_reverse" ];

  meta = with lib; {
    description = "Pytest plugin to reverse test order";
    homepage = "https://github.com/adamchainz/pytest-reverse";
    changelog = "https://github.com/adamchainz/pytest-reverse/blob/${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
