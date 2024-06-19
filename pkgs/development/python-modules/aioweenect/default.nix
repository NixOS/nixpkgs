{
  lib,
  aiohttp,
  aresponses,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "aioweenect";
  version = "1.1.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "eifinger";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-9CYdOUPCt4TkepVuVJHMZngFHyCLFwVvik1xDnfneEc=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--cov --cov-report term-missing --cov-report xml --cov=aioweenect tests" ""
  '';

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ aiohttp ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aioweenect" ];

  meta = with lib; {
    description = "Library for the weenect API";
    homepage = "https://github.com/eifinger/aioweenect";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
