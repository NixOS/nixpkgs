{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-dropbox-api";
  version = "0.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bdr99";
    repo = "python-dropbox-api";
    tag = finalAttrs.version;
    hash = "sha256-J3xgcDULK7Z+2HiarvpV6H+Na80PnfKJcdi3RRUcLzs=";
  };

  build-system = [ poetry-core ];

  dependencies = [ aiohttp ];

  pythonImportsCheck = [ "python_dropbox_api" ];

  meta = {
    description = "Lightweight wrapper for the Dropbox API intended for use in Home Assistant";
    homepage = "https://github.com/bdr99/python-dropbox-api";
    changelog = "https://github.com/bdr99/python-dropbox-api/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
