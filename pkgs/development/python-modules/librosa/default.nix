{ stdenv
, buildPythonPackage
, fetchPypi
, joblib
, matplotlib
, six
, scikitlearn
, decorator
, audioread
, resampy
}:

buildPythonPackage rec {
  pname = "librosa";
  version = "0.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cca58a2d9a47e35be63a3ce36482d241453bfe9b14bde2005430f969bd7d013a";
  };

  propagatedBuildInputs = [ joblib matplotlib six scikitlearn decorator audioread resampy ];

  # No tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python module for audio and music processing";
    homepage = http://librosa.github.io/;
    license = licenses.isc;
  };

}
