{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, pytz
, simplejson
, packaging
}:

buildPythonPackage rec {
  pname = "marshmallow";
  version = "3.16.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "marshmallow-code";
    repo = pname;
    rev = version;
    hash = "sha256-bR10hYViK7OrAaBpKaeM7S5XyHQZhlGUQTwH/EJ0kME=";
  };

  propagatedBuildInputs = [
    packaging
  ];

  checkInputs = [
    pytestCheckHook
    pytz
    simplejson
  ];

  pythonImportsCheck = [
    "marshmallow"
  ];

  meta = with lib; {
    description = "Library for converting complex objects to and from simple Python datatypes";
    homepage = "https://github.com/marshmallow-code/marshmallow";
    license = licenses.mit;
    maintainers = with maintainers; [ cript0nauta ];
  };
}
