{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, poetry-core
, aiohttp
, setuptools
}:

buildPythonPackage rec {
  pname = "aiomusiccast";
  version = "0.14.7";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "vigonotion";
    repo = "aiomusiccast";
    rev = "refs/tags/${version}";
    hash = "sha256-6fHTZ5zFiXuyFtZj9cNH5ejLbzx/1cEBUy+fs+Q6O4Y=";
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
    setuptools
  ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [
    "aiomusiccast"
  ];

  meta = with lib; {
    description = "Companion library for musiccast devices intended for the Home Assistant integration";
    homepage = "https://github.com/vigonotion/aiomusiccast";
    changelog = "https://github.com/vigonotion/aiomusiccast/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
