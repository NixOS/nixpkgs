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
  pname   = "hickle";
  version = "5.0.2";
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
    pytestCheckHook scipy pandas astropy
  ];

  pythonImportsCheck = [ "hickle" ];

  meta = {
    description = "Serialize Python data to HDF5";
    homepage = "https://github.com/telegraphic/hickle";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
