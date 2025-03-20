{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
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
  version = "1.10.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "psd-tools";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-62Q8eMPPW12HnoBDwAM3+48BEarEqLzEnHcG3TR5XDc=";
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

  meta = with lib; {
    description = "Python package for reading Adobe Photoshop PSD files";
    mainProgram = "psd-tools";
    homepage = "https://github.com/kmike/psd-tools";
    changelog = "https://github.com/psd-tools/psd-tools/blob/v${version}/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
