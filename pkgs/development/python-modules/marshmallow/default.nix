{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pytestCheckHook
, pytz
, simplejson
}:

buildPythonPackage rec {
  pname = "marshmallow";
  version = "3.13.0";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "marshmallow-code";
    repo = pname;
    rev = version;
    sha256 = "sha256-tP/RKo2Hzxz2bT7ybRs9wGzq7TpsmzmOPi3BGuSLDA0=";
  };

  checkInputs = [
    pytestCheckHook
    pytz
    simplejson
  ];

  pythonImportsCheck = [
    "marshmallow"
  ];

  meta = with lib; {
    description = ''
      A lightweight library for converting complex objects to and from
      simple Python datatypes.
    '';
    homepage = "https://github.com/marshmallow-code/marshmallow";
    license = licenses.mit;
    maintainers = with maintainers; [ cript0nauta ];
  };
}
