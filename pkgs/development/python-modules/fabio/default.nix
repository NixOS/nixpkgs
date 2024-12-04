{
  buildPythonPackage,
  ninja,
  fetchPypi,
  meson,
  lib,
  cython,
  meson-python,
  numpy,
  lxml,
  h5py,
  hdf5plugin,
  pillow,
  tomli,
}:

buildPythonPackage rec {
  pname = "fabio";
  version = "2024.9.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+HPfUfRoUxwRqufgzYihTyIfTvCUMfvFpspnse1HU1s=";
  };

  pythonImportsCheck = [ "fabio" ];

  nativeBuildInputs = [
    meson
    cython
    meson-python
    ninja
  ];

  # While building, it tries to run version.py, which has a #!/usr/bin/env python3 shebang
  postPatch = ''
    patchShebangs --build version.py
  '';

  dependencies = [
    numpy
    lxml
    h5py
    hdf5plugin
    pillow
    tomli
  ];

  meta = {
    changelog = "https://github.com/silx-kit/fabio/blob/main/doc/source/Changelog.rst";
    description = "I/O library for images produced by 2D X-ray detector";
    homepage = "https://github.com/silx-kit/fabio";
    license = [ lib.licenses.mit ];
    maintainers = [ lib.maintainers.pmiddend ];
  };

}
