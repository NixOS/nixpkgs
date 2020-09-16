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
, pytestcov
, pytestrunner
, coveralls
, twine
, check-manifest
, lib
}:

buildPythonPackage rec {
  pname   = "hickle";
  version = "4.0.1";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fcf2c4f9e4b7f0d9dae7aa6c59a58473884017875d3b17898d56eaf8a9c1da96";
  };

  postPatch = ''
    substituteInPlace requirements_test.txt \
      --replace 'astropy<3.1;' 'astropy;' --replace 'astropy<3.0;' 'astropy;'
  '';

  propagatedBuildInputs = [ h5py numpy dill ];

  doCheck = false; # incompatible with latest astropy
  checkInputs = [
    pytest pytestcov pytestrunner coveralls scipy pandas astropy twine check-manifest codecov
  ];

  pythonImportsCheck = [ "hickle" ];

  meta = {
    description = "Serialize Python data to HDF5";
    homepage = "https://github.com/telegraphic/hickle";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
