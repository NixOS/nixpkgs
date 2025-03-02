{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  pytestCheckHook,
  httpretty,
  responses,
}:

buildPythonPackage rec {
  pname = "fixerio";
  version = "1.0.0-alpha";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "amatellanes";
    repo = pname;
    rev = "v${version}";
    sha256 = "009h1mys175xdyznn5bl980vly40544s4ph1zcgqwg2i2ic93gvb";
  };

  propagatedBuildInputs = [ requests ];

  nativeCheckInputs = [
    httpretty
    pytestCheckHook
    responses
  ];

  disabledTests = [
    # tests require network access
    "test_returns_historical_rates_for_symbols_passed_if_both"
    "test_returns_historical_rates_for_symbols_passed_in_constructor"
    "test_returns_historical_rates_for_symbols_passed_in_method"
    "test_returns_latest_rates_for_symbols_passed_in_constructor"
    "test_returns_latest_rates_for_symbols_passed_in_method"
    "test_returns_latest_rates_for_symbols_passed_in_method_if_both"
  ];

  pythonImportsCheck = [ "fixerio" ];

  meta = with lib; {
    description = "Python client for Fixer.io";
    longDescription = ''
      Fixer.io is a free JSON API for current and historical foreign
      exchange rates published by the European Central Bank.
    '';
    homepage = "https://github.com/amatellanes/fixerio";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
