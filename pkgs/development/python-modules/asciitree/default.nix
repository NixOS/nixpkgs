{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "asciitree";
  version = "0.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mbr";
    repo = "asciitree";
    rev = version;
    hash = "sha256-AaLDO27W6fGHGU11rRpBf5gg1we+9SS1MEJdFP2lPBw=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Draws ASCII trees";
    homepage = "https://github.com/mbr/asciitree";
    license = licenses.mit;
    maintainers = [ ];
  };
}
