{
  aiohttp,
  beautifulsoup4,
  buildPythonPackage,
  colorlog,
  fetchFromGitHub,
  langcodes,
  lib,
  orjson,
  poetry-core,
  pytest-cov-stub,
  pytestCheckHook,
  yarl,
}:

buildPythonPackage rec {
  pname = "aioamazondevices";
  version = "6.2.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chemelli74";
    repo = "aioamazondevices";
    tag = "v${version}";
    hash = "sha256-73z4mWWBfJLewLFQvhSj7hIOfBzcwIVrNlyPPAk7PPM=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    beautifulsoup4
    colorlog
    langcodes
    orjson
    yarl
  ];

  pythonImportsCheck = [ "aioamazondevices" ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/chemelli74/aioamazondevices/blob/${src.tag}/CHANGELOG.md";
    description = "Python library to control Amazon devices";
    homepage = "https://github.com/chemelli74/aioamazondevices";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
