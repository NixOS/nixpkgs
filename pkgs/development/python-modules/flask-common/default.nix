{
  lib,
  fetchPypi,
  buildPythonPackage,
  crayons,
  flask,
  flask-caching,
  gunicorn,
  maya,
  meinheld,
  whitenoise,
}:

buildPythonPackage rec {
  pname = "flask-common";
  version = "0.3.0";

  src = fetchPypi {
    pname = "Flask-Common";
    inherit version;
    sha256 = "13d99f2dbc0a332b8bc4b2cc394d3e48f89672c266868e372cd9d7b433d921a9";
  };

  propagatedBuildInputs = [
    crayons
    flask
    flask-caching
    gunicorn
    maya
    meinheld
    whitenoise
  ];

  meta = with lib; {
    description = "Flask extension with lots of common time-savers";
    homepage = "https://github.com/kennethreitz/flask-common";
    license = licenses.asl20; # XXX: setup.py lists BSD but git repo has Apache 2.0 LICENSE
  };
}
