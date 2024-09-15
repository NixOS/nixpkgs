{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pygobject-stubs";
  version = "2.11.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pygobject";
    repo = "pygobject-stubs";
    rev = "refs/tags/v${version}";
    hash = "sha256-HOAG5c0fjF6RzULc1IDk7hRSlKTqtdXEM6acyJeV0DE=";
  };

  build-system = [ setuptools ];

  # This package does not include any tests.
  doCheck = false;

  meta = with lib; {
    description = "PEP 561 Typing Stubs for PyGObject";
    homepage = "https://github.com/pygobject/pygobject-stubs";
    changelog = "https://github.com/pygobject/pygobject-stubs/blob/${version}/CHANGELOG.md";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ hacker1024 ];
  };
}
