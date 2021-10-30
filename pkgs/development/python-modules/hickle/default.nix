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
  version = "4.0.4";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0d35030a76fe1c7fa6480088cde932689960ed354a2539ffaf5f3c90c578c06f";
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
