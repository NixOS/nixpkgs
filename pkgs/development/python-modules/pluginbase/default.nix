{ stdenv, fetchPypi, buildPythonPackage, pytest, tox }:

buildPythonPackage rec {
  version = "0.7";
  pname = "pluginbase";

  buildInputs = [ pytest tox ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "c0abe3218b86533cca287e7057a37481883c07acef7814b70583406938214cc8";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/mitsuhiko/pluginbase;
    description = "A support library for building plugins sytems in Python";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
