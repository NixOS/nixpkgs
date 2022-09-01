{ buildPythonPackage
, fetchPypi
, pythonOlder
, h5py
, numpy
, dill
, astropy
, scipy
, pandas
, codecov
, pytest
, pytest-cov
, pytest-runner
, coveralls
, twine
, check-manifest
, lib
}:

buildPythonPackage rec {
  pname   = "hickle";
  version = "5.0.2";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-2+7OF/a89jK/zLhbk/Q2A+zsKnfRbq3YMKGycEWsLEQ=";
  };

  postPatch = ''
    substituteInPlace requirements_test.txt \
      --replace 'astropy<3.1;' 'astropy;' --replace 'astropy<3.0;' 'astropy;'
  '';

  propagatedBuildInputs = [ h5py numpy dill ];

  doCheck = false; # incompatible with latest astropy
  checkInputs = [
    pytest pytest-cov pytest-runner coveralls scipy pandas astropy twine check-manifest codecov
  ];

  pythonImportsCheck = [ "hickle" ];

  meta = {
    # incompatible with h5py>=3.0, see https://github.com/telegraphic/hickle/issues/143
    broken = true;
    description = "Serialize Python data to HDF5";
    homepage = "https://github.com/telegraphic/hickle";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
