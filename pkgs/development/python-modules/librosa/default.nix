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
  version = "0.6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2aa868b8aade749b9904eeb7034fcf44115601c367969b6d01f5e1b4b9b6031d";
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
