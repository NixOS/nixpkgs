{ buildPythonPackage
, fetchPypi
, pythonOlder
, h5py
, numpy
, dill
, astropy
, scipy
, pandas
, pytestCheckHook
, lib
}:

buildPythonPackage rec {
  pname = "hickle";
  version = "5.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2+7OF/a89jK/zLhbk/Q2A+zsKnfRbq3YMKGycEWsLEQ=";
  };

  postPatch = ''
    substituteInPlace tox.ini --replace "--cov=./hickle" ""
  '';

  propagatedBuildInputs = [ h5py numpy dill ];

  nativeCheckInputs = [
    pytestCheckHook
    scipy
    pandas
    astropy
  ];

  pythonImportsCheck = [ "hickle" ];

  disabledTests = [
    # broken in 5.0.2 with recent NumPy
    # see https://github.com/telegraphic/hickle/issues/174
    "test_scalar_compression"
    # broken in 5.0.2 with python 3.11
    # see https://github.com/telegraphic/hickle/issues/169
    "test_H5NodeFilterProxy"
  ];

  meta = {
    description = "Serialize Python data to HDF5";
    homepage = "https://github.com/telegraphic/hickle";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
