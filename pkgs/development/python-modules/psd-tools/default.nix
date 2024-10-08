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
  version = "1.10.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "psd-tools";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-H3Szd8/NjXCkWyG/q+6O5L0Iq5u/g4UNdEmhDqQsAY8=";
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
