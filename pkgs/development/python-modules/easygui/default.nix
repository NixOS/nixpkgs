{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "easygui";
  version = "0.98.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1zmvmwgxyzvm83818skhn8b4wrci4kmnixaax8q3ia5cn7xrmj6v";
  };

  doCheck = false; # No tests available

  meta = with stdenv.lib; {
    description = "Very simple, very easy GUI programming in Python";
    homepage = https://github.com/robertlugg/easygui;
    license = licenses.bsd3;
    maintainers = with maintainers; [ jfrankenau ];
  };
}
