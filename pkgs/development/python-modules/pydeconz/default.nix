{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  orjson,
  pytest-aiohttp,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pydeconz";
  version = "116";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "Kane610";
    repo = "deconz";
    rev = "refs/tags/v${version}";
    hash = "sha256-XtcAs+xKSTJcQN0mCj6ewkT7owvA7nlZ8PhWfL9NZh8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "--cov=pydeconz --cov-report term-missing" "" \
      --replace-fail "setuptools==" "setuptools>=" \
      --replace-fail "wheel==" "wheel>="
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    aiohttp
    orjson
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pydeconz" ];

  meta = with lib; {
    description = "Python library wrapping the Deconz REST API";
    homepage = "https://github.com/Kane610/deconz";
    changelog = "https://github.com/Kane610/deconz/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "pydeconz";
  };
}
