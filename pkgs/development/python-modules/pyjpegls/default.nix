{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  charls,
  cython,
  numpy,
  pillow,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyjpegls";
  version = "1.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pydicom";
    repo = "pyjpegls";
    tag = "v${version}";
    hash = "sha256-ha/nYvfzgoZDpVolMKMG9ZXqojy6x/2oPcvbWDvdKk4=";
  };

  # replace vendored 'charls' submodule with Nixpkgs's:
  postPatch = ''
    rmdir lib/charls
    cp -ar ${charls.src} lib/charls
  '';

  pythonRelaxDeps = [ "numpy" ];

  build-system = [
    cython
    numpy
    setuptools
  ];

  dependencies = [
    numpy
    pillow
  ];

  pythonImportsCheck = [ "jpeg_ls" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "JPEG-LS for Python via CharLS C++ Library";
    homepage = "https://github.com/pydicom/pyjpegls";
    changelog = "https://github.com/pydicom/pyjpegls/releases/tag/v${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
