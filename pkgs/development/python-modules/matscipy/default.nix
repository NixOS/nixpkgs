{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,
  setuptools,
  meson,
  meson-python,
  ninja,
  cython,
  numpy,
  scipy,
  ase,
  packaging,
}:

buildPythonPackage rec {
  pname = "matscipy";
  version = "1.1.1";
  pyproject = true;

  build-system = [
    meson
    meson-python
    ninja
    cython
    numpy
  ];

  src = fetchFromGitHub {
    owner = "libAtoms";
    repo = "matscipy";
    tag = "v${version}";
    hash = "sha256-mVN+9PTwEMD24KV3Eyp0Jq4vgA1Zs+jThdEbVcfs6pw=";
  };

  dependencies = [
    numpy #>=1.16.0, <2.0.0
    scipy #>+1.2.3
    ase #>=3.23.0
    packaging
  ];

  meta = {
    description = "Generic Python Materials Science tools";
    homepage = "https://github.com/libAtoms/matscipy";
    changelog = "https://github.com/libAtoms/matscipy/releases/tag/v${version}";
    license = with lib.licenses; [ lgpl21Only ];
    maintainers = with lib.maintainers; [ sh4k0 ];
  };
}
