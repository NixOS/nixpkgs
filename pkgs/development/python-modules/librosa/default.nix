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
, soundfile
}:

buildPythonPackage rec {
  pname = "librosa";
  version = "0.7.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "656bbda80e98e6330db1ead79cd084b13a762284834d7603fcf7cf7c0dc65f3c";
  };

  propagatedBuildInputs = [ joblib matplotlib six scikitlearn decorator audioread resampy soundfile ];

  # No tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python module for audio and music processing";
    homepage = "http://librosa.github.io/";
    license = licenses.isc;
  };

}
