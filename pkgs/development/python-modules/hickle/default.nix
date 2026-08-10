{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  h5py,
  numpy,
  dill,
  astropy,
  scipy,
  pandas,
  pytestCheckHook,
  pytest-cov-stub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "hickle";
  version = "5.0.3-unstable-2026-07-25";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "telegraphic";
    repo = "hickle";
    rev = "cd92308f564223be999230aeb708988cfb14c2e7";
    hash = "sha256-+W2svifU1yY4RfxX8zC+8g0h7pjP2hIP6DW4AJSfrVg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    dill
    h5py
    numpy
  ];

  nativeCheckInputs = [
    astropy
    pandas
    pytestCheckHook
    pytest-cov-stub
    scipy
  ];

  pythonImportsCheck = [ "hickle" ];

  meta = {
    description = "Serialize Python data to HDF5";
    homepage = "https://github.com/telegraphic/hickle";
    changelog = "https://github.com/telegraphic/hickle/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
