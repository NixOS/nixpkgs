{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cython,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "rectangle-packer";
  version = "2.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Penlect";
    repo = "rectangle-packer";
    rev = version;
    hash = "sha256-Tm1ZkWTecmQDGsTOa1AP2GtjdxVgxklLIYSBlTSfSiY=";
  };

  build-system = [
    cython
    setuptools
  ];

  pythonImportsCheck = [ "rpack" ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    rm -r rpack
  '';

  meta = with lib; {
    description = "Pack a set of rectangles into a bounding box with minimum area";
    homepage = "https://github.com/Penlect/rectangle-packer";
    license = licenses.mit;
    maintainers = with maintainers; [ fbeffa ];
  };
}
