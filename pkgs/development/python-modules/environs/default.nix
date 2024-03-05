{ lib
, buildPythonPackage
, dj-database-url
, dj-email-url
, django-cache-url
, fetchFromGitHub
, marshmallow
, pytestCheckHook
, python-dotenv
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "environs";
  version = "10.3.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "sloria";
    repo = "environs";
    rev = "refs/tags/${version}";
    hash = "sha256-D6Kp8aHiUls7+cACJ3DwrS4OftA5uMbAu4l5IyR4F5U=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    marshmallow
    python-dotenv
  ];

  nativeCheckInputs = [
    dj-database-url
    dj-email-url
    django-cache-url
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "environs"
  ];

  meta = with lib; {
    description = "Python modle for environment variable parsing";
    homepage = "https://github.com/sloria/environs";
    changelog = "https://github.com/sloria/environs/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
