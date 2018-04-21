{ stdenv, fetchPypi, buildPythonPackage
, crayons, flask, flask_cache, gunicorn, maya, meinheld, whitenoise }:

buildPythonPackage rec {
  pname = "Flask-Common";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1f6ibvkxpxgczxs4qcbh5bj8rf9ggggbagi2dkaphx5w29xbbys4";
  };

  propagatedBuildInputs = [ crayons flask flask_cache gunicorn maya meinheld whitenoise ];

  meta = with stdenv.lib; {
    description = "Flask extension with lots of common time-savers";
    homepage = https://github.com/kennethreitz/flask-common;
    license = licenses.asl20; # XXX: setup.py lists BSD but git repo has Apache 2.0 LICENSE
  };
}
