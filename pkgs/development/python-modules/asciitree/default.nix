{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "asciitree";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mbr";
    repo = "asciitree";
    rev = version;
    hash = "sha256-67GWk6K2AyEyt5lzL0LMRnY+Uxtsig6ld2rNTvZe5ro=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Draws ASCII trees";
    homepage = "https://github.com/mbr/asciitree";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
