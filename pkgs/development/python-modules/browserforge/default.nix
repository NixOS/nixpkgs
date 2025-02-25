{
  lib,
  aiofiles,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  httpx,
  orjson,
  poetry-core,
  pythonOlder,
  rich,
}:

buildPythonPackage rec {
  pname = "browserforge";
  version = "1.1.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "daijro";
    repo = "browserforge";
    tag = "v${version}";
    hash = "sha256-+uBKVugPScr0gggYaxAdelLKKrmXGY6rWTwhFqBMTcA=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiofiles
    click
    httpx
    orjson
    rich
  ];

  # Module has no test
  doCheck = false;

  pythonImportsCheck = [ "browserforge" ];

  meta = {
    description = "Intelligent browser header & fingerprint generator";
    homepage = "https://github.com/daijro/browserforge";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
