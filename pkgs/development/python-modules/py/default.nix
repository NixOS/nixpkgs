{ stdenv, buildPythonPackage, fetchPypi, setuptools_scm }:

buildPythonPackage rec {
  pname = "py";
  version = "1.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0lsy1gajva083pzc7csj1cvbmminb7b4l6a0prdzyb3fd829nqyw";
  };

  # Circular dependency on pytest
  doCheck = false;

  buildInputs = [ setuptools_scm ];

  meta = with stdenv.lib; {
    description = "Library with cross-python path, ini-parsing, io, code, log facilities";
    homepage = https://pylib.readthedocs.org/;
    license = licenses.mit;
  };
}
