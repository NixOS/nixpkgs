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
  version = "3.20.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "marshmallow-code";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-sPYiup7ontnubtBxv+rIT0up4IHPJNCUlH9J4FlHsss=";
  };

  propagatedBuildInputs = [
    packaging
  ];

  nativeCheckInputs = [
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
    changelog = "https://github.com/marshmallow-code/marshmallow/blob/${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ cript0nauta ];
  };
}
