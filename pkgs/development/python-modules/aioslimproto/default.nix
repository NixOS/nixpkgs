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
  version = "3.1.1";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "aioslimproto";
    tag = version;
    hash = "sha256-L52Y6nOE77t0+vx4t2Ix39Xk0zxJklaGbBDuwWo1qek=";
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

  meta = with lib; {
    description = "Module to control Squeezebox players";
    homepage = "https://github.com/home-assistant-libs/aioslimproto";
    changelog = "https://github.com/home-assistant-libs/aioslimproto/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
