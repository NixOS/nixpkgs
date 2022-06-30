{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest
, pytest-cov
, numpy
, scipy
, cython
, numba
, six
}:

buildPythonPackage rec {
  pname = "resampy";
  version = "0.3.0";

  # No tests in PyPi Archive
  src = fetchFromGitHub {
    owner = "bmcfee";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-OVj5dQafIoKeA04yTGBKTinldMjEccxrdiuRFIvRzcE=";
  };

  checkInputs = [ pytest pytest-cov ];
  propagatedBuildInputs = [ numpy scipy cython numba six ];

  checkPhase = ''
    pytest tests
  '';

  meta = with lib; {
    homepage = "https://github.com/bmcfee/resampy";
    description = "Efficient signal resampling";
    license = licenses.isc;
  };

}
