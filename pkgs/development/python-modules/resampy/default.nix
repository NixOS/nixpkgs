{ stdenv
, buildPythonPackage
, fetchFromGitHub
, pytest
, pytestcov
, numpy
, scipy
, cython
, numba
, six
}:

buildPythonPackage rec {
  pname = "resampy";
  version = "0.2.1";

  # No tests in PyPi Archive
  src = fetchFromGitHub {
    owner = "bmcfee";
    repo = pname;
    rev = version;
    sha256 = "0a2bxj042y62dimm2i4vglbhpwbybam07mcl67cb6pmfsw9fbqhj";
  };

  checkInputs = [ pytest pytestcov ];
  propagatedBuildInputs = [ numpy scipy cython numba six ];

  checkPhase = ''
    pytest tests
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/bmcfee/resampy;
    description = "Efficient signal resampling";
    license = licenses.isc;
  };

}
