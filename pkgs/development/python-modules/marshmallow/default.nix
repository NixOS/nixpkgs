{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, pytz
, simplejson
, packaging
, setuptools
}:

buildPythonPackage rec {
  pname = "marshmallow";
  version = "3.20.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "marshmallow-code";
    repo = "marshmallow";
    rev = "refs/tags/${version}";
    hash = "sha256-z6Quf6uTelGwB/uYayVXtVmculwaoI5LL8I0kKiM/e8=";
  };

  nativeBuildInputs = [
    setuptools
  ];

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
