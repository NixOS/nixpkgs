{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  version = "1.0.3";
  pname = "python-editor";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a3c066acee22a1c94f63938341d4fb374e3fdd69366ed6603d7b24bed1efc565";
  };

  # No proper tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A library that provides the `editor` module for programmatically";
    homepage = https://github.com/fmoo/python-editor;
    license = licenses.asl20;
  };
}
