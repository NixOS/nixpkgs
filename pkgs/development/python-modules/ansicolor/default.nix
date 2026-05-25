{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ansicolor";
  version = "0.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "numerodix";
    repo = "ansicolor";
    tag = version;
    hash = "sha256-ndChpcHjsGWmlw0uvPF0RvRvi99b3cnajHRXudmQXBw=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ansicolor" ];

  meta = {
    description = "Library to produce ansi color output and colored highlighting and diffing";
    homepage = "https://github.com/numerodix/ansicolor/";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
