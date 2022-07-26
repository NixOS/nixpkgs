{ lib
, buildPythonPackage
, fetchPypi
, asgiref
, click
, importlib-metadata
, itsdangerous
, jinja2
, python-dotenv
, werkzeug
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  version = "2.1.2";
  pname = "Flask";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-MV3tLd+KYoFWftsnOTAQ/jQGGIuvv+ZaMznVeH2J5Hc=";
  };

  propagatedBuildInputs = [
    asgiref
    python-dotenv
    click
    itsdangerous
    jinja2
    werkzeug
  ] ++ lib.optional (pythonOlder "3.10") importlib-metadata;

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    homepage = "https://flask.palletsprojects.com/";
    description = "The Python micro framework for building web applications";
    longDescription = ''
      Flask is a lightweight WSGI web application framework. It is
      designed to make getting started quick and easy, with the ability
      to scale up to complex applications. It began as a simple wrapper
      around Werkzeug and Jinja and has become one of the most popular
      Python web application frameworks.
    '';
    license = licenses.bsd3;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
