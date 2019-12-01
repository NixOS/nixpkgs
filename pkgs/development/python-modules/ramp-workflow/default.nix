{ stdenv
, buildPythonPackage
, fetchFromGitHub
, numpy
, scipy
, pandas
, scikitlearn
, cloudpickle
, click
, pytest
, pytestcov
, codecov
, flake8
, nbconvert
, jupyter_client
, seaborn
, netcdf4
, xarray
, scikitimage
, joblib
, Keras
, tensorflow
}:

buildPythonPackage rec {
  pname = "ramp-workflow";
  version = "v0.2.0+53.gf48b024";

  # checks not working atm
  # see https://github.com/paris-saclay-cds/ramp-workflow/issues/192
  doCheck = false;
  checkInputs = [
    pytest pytestcov codecov flake8 nbconvert jupyter_client seaborn netcdf4 xarray scikitimage joblib Keras tensorflow
  ];

  propagatedBuildInputs = [
    numpy scipy pandas scikitlearn cloudpickle click
  ];

  src = fetchFromGitHub {
    owner = "paris-saclay-cds";
    repo = pname;
    rev = "f48b024642c0756d9e12717067cbca224e34b9ce";
    sha256 = "1xlw3jyfn3nkfbryj8dcm04h5l82w2bhds8cynik7v6mds4jxgll";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/paris-saclay-cds/ramp-workflow;
    description = "Build, manage, and optimize data analytics workflows";
    license = licenses.bsd3;
    maintainers = [ maintainers.GuillaumeDesforges ];
  };

}
