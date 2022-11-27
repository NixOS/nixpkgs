{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, pytestCheckHook
, pytz
}:

buildPythonPackage rec {
  pname = "ciso8601";
  version = "2.2.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "closeio";
    repo = "ciso8601";
    rev = "v${version}";
    sha256 = "sha256-TqB1tQDgCkXu+QuzP6yBEH/xHxhhD/kGR2S0I8Osc5E=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  checkInputs = [
    pytestCheckHook
    pytz
  ];

  pytestFlagsArray = [
    "tests/tests.py"
  ];

  pythonImportsCheck = [ "ciso8601" ];

  meta = with lib; {
    description = "Fast ISO8601 date time parser for Python written in C";
    homepage = "https://github.com/closeio/ciso8601";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
  };
}
