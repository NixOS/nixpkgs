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
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "af0b9f2ed4bbf6aecbc448a4cd27c16453c397cb6bef0f0cfba0e63afea2b839";
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
