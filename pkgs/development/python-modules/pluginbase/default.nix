{ stdenv, fetchPypi, buildPythonPackage, pytest }:

buildPythonPackage rec {
  version = "1.0.0";
  pname = "pluginbase";

  src = fetchPypi {
    inherit pname version;
    sha256 = "497894df38d0db71e1a4fbbfaceb10c3ef49a3f95a0582e11b75f8adaa030005";
  };

  checkInputs = [ pytest ];

  checkPhase = ''
    cd tests
    PYTHONPATH=.. pytest
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/mitsuhiko/pluginbase;
    description = "A support library for building plugins sytems in Python";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
