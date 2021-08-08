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
  version = "3.11.1";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "marshmallow-code";
    repo = pname;
    rev = version;
    sha256 = "1ypm142y3giaqydc7fkigm9r057yp2sd1ng5zr2x3w3wbbj5yfm6";
  };

  pythonImportsCheck = [
    "marshmallow"
  ];

  checkInputs = [
    pytestCheckHook
    pytz
    simplejson
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
