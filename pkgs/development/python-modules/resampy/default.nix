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
  version = "0.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7f6912ca2b746eb9bcdc05c52fcef088f0b7ba1ca6ee0b2d0a359d18fc57f8f8";
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
