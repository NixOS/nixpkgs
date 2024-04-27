{ lib
, buildPythonPackage
, fetchFromGitHub
, flask
}:

buildPythonPackage {
  pname = "flask-silk";
  version = "unstable-2018-06-28";

  # master fixes flask import syntax and has no major changes
  # new release requested: https://github.com/sublee/flask-silk/pull/6
  src = fetchFromGitHub {
    owner = "sublee";
    repo = "flask-silk";
    rev = "3a8166550f9a0ec52edae7bf31d9818c4c15c531";
    sha256 = "0mplziqw52jfspas6vsm210lmxqqzgj0dxm8y0i3gpbyyykwcmh0";
  };

  propagatedBuildInputs = [
    flask
  ];

  meta = with lib; {
    description = "Adds silk icons to your Flask application or module, or extension";
    license = licenses.bsd3;
    maintainers = teams.sage.members;
    homepage = "https://github.com/sublee/flask-silk";
  };
}
