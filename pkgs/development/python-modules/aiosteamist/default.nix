{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "aiosteamist";
  version = "1.0.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "aiosteamist";
    rev = "refs/tags/v${version}";
    hash = "sha256-vqCcQDUMFFhIOoiER5TMOxJPY7HYFS4K1fuu/1IqP44=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "--cov=aiosteamist" ""
  '';

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    xmltodict
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiosteamist" ];

  meta = with lib; {
    description = "Module to control Steamist steam systems";
    homepage = "https://github.com/bdraco/aiosteamist";
    changelog = "https://github.com/bdraco/aiosteamist/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
