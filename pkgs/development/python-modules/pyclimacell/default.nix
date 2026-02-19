{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pytz,
}:

buildPythonPackage rec {
  pname = "pyclimacell";
  version = "0.18.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "raman325";
    repo = "pyclimacell";
    rev = "v${version}";
    hash = "sha256-jWHjnebg4Aar48gid7bB7XYXOQtSqbmVmASsZd0YoPc=";
  };

  propagatedBuildInputs = [
    aiohttp
    pytz
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyclimacell" ];

  meta = {
    description = "Python client for ClimaCell API";
    homepage = "https://github.com/raman325/pyclimacell";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
