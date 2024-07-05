{
  lib,
  aniso8601,
  blinker,
  buildPythonPackage,
  fetchPypi,
  flask,
  mock,
  nose,
  pytestCheckHook,
  pythonOlder,
  pytz,
  six,
  werkzeug,
}:

buildPythonPackage rec {
  pname = "flask-restful";
  version = "0.3.10";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "Flask-RESTful";
    inherit version;
    hash = "sha256-/kry7wAn34+bT3l6uiDFVmgBtq3plaxjtYir8aWc7Dc=";
  };

  # conditional so that overrides are easier for web applications
  patches =
    lib.optionals (lib.versionAtLeast werkzeug.version "2.1.0") [ ./werkzeug-2.1.0-compat.patch ]
    ++ lib.optionals (lib.versionAtLeast flask.version "3.0.0") [ ./flask-3.0-compat.patch ];

  propagatedBuildInputs = [
    aniso8601
    flask
    pytz
    six
  ];

  nativeCheckInputs = [
    blinker
    mock
    nose
    pytestCheckHook
  ];

  disabledTests = [
    # Broke in flask 2.2 upgrade
    "test_exception_header_forwarded"
    # Broke in werkzeug 2.3 upgrade
    "test_media_types_method"
    "test_media_types_q"
  ];

  pythonImportsCheck = [ "flask_restful" ];

  meta = with lib; {
    description = "Framework for creating REST APIs";
    homepage = "https://flask-restful.readthedocs.io";
    longDescription = ''
      Flask-RESTful provides the building blocks for creating a great
      REST API.
    '';
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
