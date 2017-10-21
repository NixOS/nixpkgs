{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pymongo";
  version = "3.5.1";
  name  = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0939bl3brrklvccicck62gs3zd7i9aysz13c8pxc3gpk2hsdj878";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "http://github.com/mongodb/mongo-python-driver";
    license = licenses.asl20;
    description = "Python driver for MongoDB ";
  };
}
