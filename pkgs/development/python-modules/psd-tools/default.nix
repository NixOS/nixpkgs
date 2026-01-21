{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  attrs,
  docopt,
  pillow,
  scikit-image,
  scipy,
  numpy,
  aggdraw,
  pytestCheckHook,
  pytest-cov-stub,
  ipython,
  cython,
}:

buildPythonPackage rec {
  pname = "psd-tools";
  version = "1.12.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "psd-tools";
    repo = "psd-tools";
    tag = "v${version}";
    hash = "sha256-FmxxLa9KasDE5hl/Hi6fRMnmUKawpm04fHJf7yXJmSI=";
  };

  build-system = [
    setuptools
    cython
  ];

  dependencies = [
    aggdraw
    attrs
    docopt
    numpy
    pillow
    scikit-image
    scipy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    ipython
  ];

  pythonImportsCheck = [ "psd_tools" ];

  meta = {
    description = "Python package for reading Adobe Photoshop PSD files";
    mainProgram = "psd-tools";
    homepage = "https://github.com/kmike/psd-tools";
    changelog = "https://github.com/psd-tools/psd-tools/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ onny ];
  };
}
