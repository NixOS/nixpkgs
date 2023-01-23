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
  version = "3.19.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "marshmallow-code";
    repo = pname;
    rev = version;
    hash = "sha256-b1brLHM48t45bwUXk7QreLLmvTzU0sX7Uoc1ZAgGkrE=";
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
    changelog = "https://github.com/marshmallow-code/marshmallow/blob/${src.rev}/CHANGELOG.rst";
    description = "Library for converting complex objects to and from simple Python datatypes";
    homepage = "https://github.com/marshmallow-code/marshmallow";
    license = licenses.mit;
    maintainers = with maintainers; [ cript0nauta ];
  };
}
