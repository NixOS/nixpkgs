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
  version = "3.0.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "aioslimproto";
    rev = "refs/tags/${version}";
    hash = "sha256-K7z34fT0PQ5qcV+66VbhYTUhCjqW/OjPnrygBFKIW1k=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "--cov" ""
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
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
    changelog = "https://github.com/home-assistant-libs/aioslimproto/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
