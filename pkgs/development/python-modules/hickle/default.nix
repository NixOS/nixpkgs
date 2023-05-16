<<<<<<< HEAD
{ lib
, buildPythonPackage
=======
{ buildPythonPackage
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, fetchPypi
, pythonOlder
, h5py
, numpy
, dill
, astropy
, scipy
, pandas
, pytestCheckHook
<<<<<<< HEAD
}:

buildPythonPackage rec {
  pname = "hickle";
  version = "5.0.2";
  format = "setuptools";

=======
, lib
}:

buildPythonPackage rec {
  pname   = "hickle";
  version = "5.0.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2+7OF/a89jK/zLhbk/Q2A+zsKnfRbq3YMKGycEWsLEQ=";
  };

  postPatch = ''
<<<<<<< HEAD
    substituteInPlace tox.ini \
      --replace "--cov=./hickle" ""
  '';

  propagatedBuildInputs = [
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

  pythonImportsCheck = [
    "hickle"
  ];

  disabledTests = [
    # broken in 5.0.2 with recent NumPy
    # see https://github.com/telegraphic/hickle/issues/174
    "test_scalar_compression"
    # broken in 5.0.2 with Python 3.11
    # see https://github.com/telegraphic/hickle/issues/169
    "test_H5NodeFilterProxy"
    # broken in 5.0.2
    "test_slash_dict_keys"
  ];

  meta = with lib; {
    description = "Serialize Python data to HDF5";
    homepage = "https://github.com/telegraphic/hickle";
    changelog = "https://github.com/telegraphic/hickle/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
=======
    substituteInPlace tox.ini --replace "--cov=./hickle" ""
  '';

  propagatedBuildInputs = [ h5py numpy dill ];

  nativeCheckInputs = [
    pytestCheckHook scipy pandas astropy
  ];

  pythonImportsCheck = [ "hickle" ];

  meta = {
    description = "Serialize Python data to HDF5";
    homepage = "https://github.com/telegraphic/hickle";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
