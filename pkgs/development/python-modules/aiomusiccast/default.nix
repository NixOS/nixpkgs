{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, poetry-core
, aiohttp
}:

buildPythonPackage rec {
  pname = "aiomusiccast";
  version = "0.14.5";

  format = "pyproject";
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "vigonotion";
    repo = "aiomusiccast";
    rev = "refs/tags/${version}";
    hash = "sha256-YssBrG4sFtQtrzKU/O/tWEVL9eq8dpszejY/1So5Mec=";
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
