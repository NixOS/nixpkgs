{ lib, stdenv, buildPythonPackage, pythonOlder, fetchPypi, setuptools
, setuptools-scm, pytestCheckHook, pandas, numpy, toolz, korean-lunar-calendar
, pyluach }:

buildPythonPackage rec {
  pname = "exchange_calendars";
  version = "4.5";
  pyproject = true;

  disabled = pythonOlder "3.10";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gdxfksftFk33oV8LI7PrHAfk8xVi5lm0N0hrM3mgRQw=";
  };

  nativeBuildInputs = [ setuptools setuptools-scm ];

  propagatedBuildInputs = [ numpy pandas toolz korean-lunar-calendar pyluach ];

  nativeCheckinputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "exchange_calendars" ];

  meta = with lib; {
    changelog =
      "https://github.com/gerrymanoim/exchange_calendars/releases/tag/${version}";
    description = "Calendars for various securities exchanges.";
    homepage = "https://github.com/gerrymanoim/exchange_calendars";
    license = licenses.asl20;
    maintainers = with maintainers; [ techknowlogick ];
  };
}
