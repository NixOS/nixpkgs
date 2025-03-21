{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-git-versioning,

  # dependencies
  ezyrb,
  future,
  h5netcdf,
  matplotlib,
  numpy,
  scipy,
  xarray,

  # tests
  pytest-mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pydmd";
  version = "2025.03.01";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PyDMD";
    repo = "PyDMD";
    tag = version;
    hash = "sha256-2pfWW+CLSDr6tJrcLpodil/RnhLTZ5Yqw0ThTCqO0MY=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools-git-versioning>=2.0,<3" "setuptools-git-versioning"
  '';

  build-system = [
    setuptools
    setuptools-git-versioning
  ];

  dependencies = [
    ezyrb
    future
    h5netcdf
    matplotlib
    numpy
    scipy
    xarray
  ];

  pythonImportsCheck = [ "pydmd" ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ];

  meta = {
    description = "Python Dynamic Mode Decomposition";
    homepage = "https://pydmd.github.io/PyDMD/";
    changelog = "https://github.com/PyDMD/PyDMD/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yl3dy ];
  };
}
