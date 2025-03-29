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
    (fetchpatch {
      url = "https://github.com/cjwatson/hickle/commit/246d8e82c805e2e49ea0abd39abc9b2d800bde59.patch";
      hash = "sha256-IEVw2K7S1nCkzgn9q0xghm4brfXcallNjzXpt2cRq1M=";
    })
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
