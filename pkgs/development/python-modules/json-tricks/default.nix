{ lib
, fetchFromGitHub
, buildPythonPackage
, pythonOlder
, pytestCheckHook
, numpy
, pandas
, pytz
}:

buildPythonPackage rec {
  pname = "json-tricks";
  version = "3.15.5";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "mverleg";
    repo = "pyjson_tricks";
    rev = "v${version}";
    sha256 = "wdpqCqMO0EzKyqE4ishL3CTsSw3sZPGvJ0HEktKFgZU=";
  };

  nativeCheckInputs = [ numpy pandas pytz pytestCheckHook ];

  pythonImportsCheck = [ "json_tricks" ];

  meta = with lib; {
    description = "Extra features for Python JSON handling";
    homepage = "https://github.com/mverleg/pyjson_tricks";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
