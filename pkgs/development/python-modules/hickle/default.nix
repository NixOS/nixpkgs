{ buildPythonPackage
, fetchPypi
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
  version = "3.4.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "09e73029dc6c122f483fca4313a27cc483534145961e4786e65d60895054d940";
  };

  postPatch = ''
    substituteInPlace requirements_test.txt \
      --replace 'astropy<3.1;' 'astropy;' --replace 'astropy<3.0;' 'astropy;'
  '';

  propagatedBuildInputs = [ h5py numpy dill ];
  checkInputs = [
    pytest pytestcov pytestrunner coveralls scipy pandas astropy twine check-manifest codecov
  ];

  meta = {
    description = "Serialize Python data to HDF5";
    homepage = "https://github.com/telegraphic/hickle";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
