{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, poetry-core
, aiohttp
}:

buildPythonPackage rec {
  pname = "aiomusiccast";
  version = "0.14.2";

  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "vigonotion";
    repo = "aiomusiccast";
    rev = version;
    sha256 = "sha256-5xIz36FgNwcaesmkYp3EWTxCe/8RaUJOJW9dqK+eang=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
  ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [
    "aiomusiccast"
  ];

  meta = with lib; {
    description = "Companion library for musiccast devices intended for the Home Assistant integration";
    homepage = "https://github.com/vigonotion/aiomusiccast";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
