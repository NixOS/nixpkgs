{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  abxbus,
  abxpkg,
  imagesize,
  httpx,
  rich-click,
  requests,
  uv,
  websockets,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "abx-plugins";
  version = "1.13.162";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    pname = "abx_plugins";
    inherit (finalAttrs) version;
    hash = "sha256-h27ikNrMS1aC7no1vJ7AktZ+QZPGsDFO4SzFR16gyEU=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    abxbus
    abxpkg
    imagesize
    rich-click
    uv
  ];

  optional-dependencies.opencode = [
    httpx
    requests
    websockets
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # Tests invoke live network requests to resolve plugin binary downloads
  doCheck = false;

  pythonImportsCheck = [ "abx_plugins" ];

  meta = {
    changelog = "https://github.com/ArchiveBox/abx-plugins/releases";
    description = "ArchiveBox-compatible plugin suite with hooks, configs, and binary manifests for Chrome, yt-dlp, wget, and more";
    homepage = "https://github.com/ArchiveBox/abx-plugins";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
})
