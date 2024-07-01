{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  h5py,
  numpy,
  dill,
  astropy,
  scipy,
  pandas,
  pytestCheckHook,
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

  postPatch = ''
    substituteInPlace tox.ini \
      --replace-fail "--cov=./hickle" ""
  '';

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
