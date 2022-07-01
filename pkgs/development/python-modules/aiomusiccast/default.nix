{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, poetry-core
, aiohttp
}:

buildPythonPackage rec {
  pname = "aiomusiccast";
  version = "0.14.4";

  format = "pyproject";
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "vigonotion";
    repo = "aiomusiccast";
    rev = "refs/tags/${version}";
    hash = "sha256-vSf4Fcioz+ZrXCaFQQbHzhz7vOknCOEFJXduXJlO/wE=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '"0.0.0"' '"${version}"'
  '';

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
