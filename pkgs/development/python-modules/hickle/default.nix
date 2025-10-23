{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,
  pythonOlder,
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
  version = "5.0.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-An5RzK0nnRaBI6JEUl5shLrA22RgWzEbC9NJiRvgxT4=";
  };

  patches = [
    # fixes support for numpy 2.x, the PR is not yet merged https://github.com/telegraphic/hickle/pull/186
    # FIXME: Remove this patch when the numpy 2.x support arrives
    ./numpy-2.x-support.patch
    # fixes test failing with numpy 2.3 as ndarray.tostring was deleted
    # FIXME: delete once https://github.com/telegraphic/hickle/pull/187 is merged
    ./numpy-2.3-ndarray-tostring.patch
  ];

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

  meta = with lib; {
    description = "Serialize Python data to HDF5";
    homepage = "https://github.com/telegraphic/hickle";
    changelog = "https://github.com/telegraphic/hickle/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
