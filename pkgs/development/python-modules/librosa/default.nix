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
  version = "0.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "209626c53556ca3922e52d2fae767bf5b398948c867fcc8898f948695dacb247";
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
