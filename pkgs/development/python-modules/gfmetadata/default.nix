{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  protobuf,
}:

buildPythonPackage (finalAttrs: {
  pname = "gfmetadata";
  version = "0.2.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "gf-metadata";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NJ/ppuodGwuEi0wC31lMAwJLY+/jgUMANm47iMrD3no=";
  };

  build-system = [
    setuptools-scm
    setuptools
  ];

  dependencies = [
    protobuf
  ];

  pythonImportsCheck = [ "gfmetadata" ];

  meta = {
    description = "Python API for interacting with Google Fonts protobuf definitions";
    homepage = "https://github.com/googlefonts/gf-metadata";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jopejoe1 ];
  };
})
