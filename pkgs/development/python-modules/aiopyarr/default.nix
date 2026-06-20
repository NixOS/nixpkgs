{
  lib,
  aiohttp,
  aresponses,
  buildPythonPackage,
  ciso8601,
  fetchFromGitHub,
  orjson,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiopyarr";
  version = "23.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tkdrob";
    repo = "aiopyarr";
    tag = finalAttrs.version;
    hash = "sha256-CzNB6ymvDTktiOGdcdCvWLVQ3mKmbdMpc/vezSXCpG4=";
  };

  build-system = [ setuptools ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail 'version="master"' 'version="${finalAttrs.version}"'
  '';

  dependencies = [
    aiohttp
    ciso8601
    orjson
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiopyarr" ];

  meta = {
    description = "Python API client for Lidarr/Radarr/Readarr/Sonarr";
    homepage = "https://github.com/tkdrob/aiopyarr";
    changelog = "https://github.com/tkdrob/aiopyarr/releases/tag/${finalAttrs.version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
})
