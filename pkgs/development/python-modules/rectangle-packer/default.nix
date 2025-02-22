{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  # build system
  cython,
  setuptools,
}:

buildPythonPackage rec {
  pname = "rectangle-packer";
  version = "2024-10-26";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Penlect";
    repo = "rectangle-packer";
    rev = "46fa636fc8637081845151b4a0b16e8f60a57638";
    sha256 = "sha256-9mXfa9tDB2QE6hHxOxk9XvUjiov0dUBX54X4uRxwSvQ=";
  };

  build-system = [ cython setuptools ];

  dependencies = [ ];

  nativeCheckInputs = [ ];

  pythonImportsCheck = [ "rpack" ];

  meta = with lib; {
    description = "A Python module for rectangle packing utilities.";
    homepage = "https://github.com/Penlect/rectangle-packer";
    license = licenses.mit;
    maintainers = [ ];
  };
}
