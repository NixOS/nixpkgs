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
  version = "3.20.2";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "marshmallow-code";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-z6Quf6uTelGwB/uYayVXtVmculwaoI5LL8I0kKiM/e8=";
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
