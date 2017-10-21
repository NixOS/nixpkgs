{ stdenv, fetchPypi, buildPythonPackage, pytest, tox }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  version = "0.5";
  pname = "pluginbase";

  buildInputs = [ pytest tox ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "1palagrlszs4f4f5j6npzl4d195vclrlza3qr524z2h758j31y5l";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/mitsuhiko/pluginbase;
    description = "A support library for building plugins sytems in Python";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
