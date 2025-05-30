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
  version = "1.2.3";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "daijro";
    repo = "browserforge";
    tag = "v${version}";
    hash = "sha256-D5GlUZ4KT6kqPQVcpli8T++xoXl1YUVGZu8rePJQ44A=";
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
