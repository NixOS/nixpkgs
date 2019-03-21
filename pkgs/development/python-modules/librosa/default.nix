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
  version = "0.6.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b332225ac29bfae1ba386deca2b6566271576de3ab17617ad0a71892c799b118";
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
