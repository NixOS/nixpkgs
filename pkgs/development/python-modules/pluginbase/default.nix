{ stdenv, fetchPypi, buildPythonPackage, pytest, tox }:

buildPythonPackage rec {
  version = "1.0.0";
  pname = "pluginbase";

  buildInputs = [ pytest tox ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "497894df38d0db71e1a4fbbfaceb10c3ef49a3f95a0582e11b75f8adaa030005";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/mitsuhiko/pluginbase;
    description = "A support library for building plugins sytems in Python";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
