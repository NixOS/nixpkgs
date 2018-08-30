{ stdenv, buildPythonPackage, fetchPypi, pytestrunner, pytest }:

buildPythonPackage rec {
  pname = "Cerberus";
  version = "1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f5c2e048fb15ecb3c088d192164316093fcfa602a74b3386eefb2983aa7e800a";
  };

  checkInputs = [ pytestrunner pytest ];

  meta = with stdenv.lib; {
    homepage = http://python-cerberus.org/;
    description = "Lightweight, extensible schema and data validation tool for Python dictionaries";
    license = licenses.mit;
  };
}
