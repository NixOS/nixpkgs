{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  mslex,
}:

buildPythonPackage rec {
  pname = "oslex";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "petamas";
    repo = "oslex";
    tag = "release/v${version}";
    hash = "sha256-BTyLL3tb1P8VMGvTgoHGmwvFqf3gOyXOI+YmHuEjrKc=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    mslex
  ];

  pythonImportsCheck = [
    "oslex"
  ];

  meta = {
    description = "OS-independent wrapper for shlex and mslex";
    homepage = "https://github.com/petamas/oslex";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yzx9 ];
  };
}
