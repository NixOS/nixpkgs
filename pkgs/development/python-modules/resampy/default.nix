{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, pytestcov
, numpy
, scipy
, cython
, six
}:

buildPythonPackage rec {
  pname = "resampy";
  version = "0.1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cf4f149d8699af70a1b4b0769fa16fab21835d936ea7ff25e98446aa49e743d4";
  };

  checkInputs = [ pytest pytestcov ];
  propagatedBuildInputs = [ numpy scipy cython six ];

  # No tests included
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/bmcfee/resampy;
    description = "Efficient signal resampling";
    license = licenses.isc;
  };

}
