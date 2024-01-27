{ lib
, buildPythonPackage
, fetchPypi
, flask
, flask-silk
, future
, pythonOlder
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "flask-autoindex";
  version = "0.6.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "Flask-AutoIndex";
    inherit version;
    sha256 = "ea319f7ccadf68ddf98d940002066278c779323644f9944b300066d50e2effc7";
  };

  propagatedBuildInputs = [
    flask
    flask-silk
    future
  ];

  nativeCheckInputs = [
    unittestCheckHook
  ];

  pythonImportsCheck = [
    "flask_autoindex"
  ];

  meta = with lib; {
    description = "The mod_autoindex for Flask";
    longDescription = ''
      Flask-AutoIndex generates an index page for your Flask application automatically.
      The result is just like mod_autoindex, but the look is more awesome!
    '';
    homepage = "https://flask-autoindex.readthedocs.io/";
    changelog = "https://github.com/general03/flask-autoindex/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd2;
    maintainers = teams.sage.members;
    # https://github.com/general03/flask-autoindex/issues/67
    broken = true;
  };
}
