{ lib
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
, pooch
}:

buildPythonPackage rec {
  pname = "librosa";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "af0b9f2ed4bbf6aecbc448a4cd27c16453c397cb6bef0f0cfba0e63afea2b839";
  };

  propagatedBuildInputs = [ joblib matplotlib six scikitlearn decorator audioread resampy soundfile pooch ];

  # No tests
  # 1. Internet connection is required
  # 2. Got error "module 'librosa' has no attribute 'version'"
  doCheck = false;

  # check that import works, this allows to capture errors like https://github.com/librosa/librosa/issues/1160
  pythonImportsCheck = [ "librosa" ];

  meta = with lib; {
    description = "Python module for audio and music processing";
    homepage = "http://librosa.github.io/";
    license = licenses.isc;
    maintainers = with maintainers; [ GuillaumeDesforges ];
  };

}
