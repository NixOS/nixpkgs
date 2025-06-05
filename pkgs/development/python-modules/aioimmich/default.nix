{
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  mashumaro,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
  syrupy,
}:

buildPythonPackage rec {
  pname = "aioimmich";
  version = "0.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mib1185";
    repo = "aioimmich";
    tag = "v${version}";
    hash = "sha256-s2W/Z/psCLvd7zMsaaYi3ZIcEuuRSpyRSvUUfIPe8a4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail setuptools==80.9.0 setuptools
  '';

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    mashumaro
  ];

  pythonImportsCheck = [ "aioimmich" ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
    syrupy
  ];

  meta = {
    changelog = "https://github.com/mib1185/aioimmich/releases/tag/${src.tag}";
    description = "Asynchronous library to fetch albums and assests from immich";
    homepage = "https://github.com/mib1185/aioimmich";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
