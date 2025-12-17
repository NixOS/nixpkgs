{
  lib,
  aiohttp,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  pillow,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aioslimproto";
  version = "3.1.2";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "aioslimproto";
    tag = version;
    hash = "sha256-NrMcM3pIzTw9FkfVDptIIdIya7jHtwwzT7RRJTmB40c=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${version}"'
  '';

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    async-timeout
    pillow
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "aioslimproto" ];

  meta = {
    description = "Module to control Squeezebox players";
    homepage = "https://github.com/home-assistant-libs/aioslimproto";
    changelog = "https://github.com/home-assistant-libs/aioslimproto/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
