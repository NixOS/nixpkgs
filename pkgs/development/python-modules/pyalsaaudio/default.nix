{ stdenv, fetchPypi, buildPythonPackage
, alsaLib }:

buildPythonPackage rec {
  pname = "pyalsaaudio";
  version = "0.8.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "84e8f8da544d7f4bd96479ce4a237600077984d9be1d7f16c1d9a492ecf50085";
  };

  buildInputs = [ alsaLib ];

  # it requires physical hardware for testing
  doCheck = false;

  meta = with stdenv.lib; {
    description = "ALSA bindings";
    homepage = http://larsimmisch.github.io/pyalsaaudio;
    license = licenses.psfl;
  };
}
