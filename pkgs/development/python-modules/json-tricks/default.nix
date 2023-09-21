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
  version = "3.17.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mverleg";
    repo = "pyjson_tricks";
    rev = "refs/tags/v${version}";
    hash = "sha256-xddMc4PvVI+mqB3eeVqECZmdeSKAURsdbOnUAXahqM0=";
  };

  nativeCheckInputs = [
    numpy
    pandas
    pytz
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "json_tricks"
  ];

  meta = with lib; {
    description = "Extra features for Python JSON handling";
    homepage = "https://github.com/mverleg/pyjson_tricks";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
