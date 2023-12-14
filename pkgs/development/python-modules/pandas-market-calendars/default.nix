{ lib, stdenv, buildPythonPackage, pythonOlder, fetchPypi, setuptools
, pytestCheckHook, pandas, exchange-calendars }:

buildPythonPackage rec {
  pname = "pandas-market-calendars";
  version = "4.3.1";
  pyproject = true;

  disabled = pythonOlder "3.10";
  src = fetchPypi {
    inherit version;
    pname = "pandas_market_calendars";
    hash = "sha256-xdqYZVlcVZbF+rmZTXlv0LSHjU1895Dcf0wix001p+o=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ pandas exchange-calendars ];

  nativeCheckinputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pandas_market_calendars" ];

  meta = with lib; {
    changelog =
      "https://github.com/rsheftel/pandas_market_calendars/releases/tag/${version}";
    description =
      "Exchange calendars to use with pandas for trading applications";
    homepage = "https://github.com/rsheftel/pandas_market_calendars";
    license = licenses.mit;
    maintainers = with maintainers; [ techknowlogick ];
  };
}
