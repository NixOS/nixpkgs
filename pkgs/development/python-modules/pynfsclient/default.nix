{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pynfsclient";
  version = "1.0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Pennyw0rth";
    repo = "NfsClient";
    rev = "v${version}";
    hash = "sha256-9PV/RpK/rOI9jpTDy0FmkXY2Cf54vve6j1kM5dcZgV8=";
  };

  build-system = [ setuptools ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "pyNfsClient" ];

  meta = {
    description = "Pure python library to simulate NFS client";
    homepage = "https://github.com/Pennyw0rth/NfsClient";
    changelog = "https://github.com/Pennyw0rth/NfsClient/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      fab
      letgamer
    ];
  };
}
