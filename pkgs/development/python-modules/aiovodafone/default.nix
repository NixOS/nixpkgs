{
  lib,
  aiohttp,
  beautifulsoup4,
  buildPythonPackage,
  colorlog,
  cryptography,
  fetchFromGitHub,
  orjson,
  poetry-core,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "aiovodafone";
  version = "3.1.1";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "chemelli74";
    repo = "aiovodafone";
    tag = "v${version}";
    hash = "sha256-NhtclSuwiEuGAA/zhKEL/5S/WTFTjo87BTQPuSVX0sE=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    beautifulsoup4
    cryptography
    colorlog
    orjson
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiovodafone" ];

  meta = {
    description = "Library to control Vodafon Station";
    homepage = "https://github.com/chemelli74/aiovodafone";
    changelog = "https://github.com/chemelli74/aiovodafone/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
