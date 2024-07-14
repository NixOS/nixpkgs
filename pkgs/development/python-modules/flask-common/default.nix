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
    hash = "sha256-E9mfLbwKMyuLxLLMOU0+SPiWcsJmho43LNnXtDPZIak=";
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
