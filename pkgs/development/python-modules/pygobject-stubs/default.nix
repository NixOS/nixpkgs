{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pygobject-stubs";
  version = "2.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pygobject";
    repo = "pygobject-stubs";
    tag = "v${version}";
    hash = "sha256-pConIc8FBq2a7yrfRHa07p2e/Axgrv4p+W0nq1WzERw=";
  };

  build-system = [ setuptools ];

  # This package does not include any tests.
  doCheck = false;

  meta = {
    description = "PEP 561 Typing Stubs for PyGObject";
    homepage = "https://github.com/pygobject/pygobject-stubs";
    changelog = "https://github.com/pygobject/pygobject-stubs/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ hacker1024 ];
  };
}
