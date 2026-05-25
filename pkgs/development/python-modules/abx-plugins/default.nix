{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  abxbus,
  abxpkg,
  jambo,
  rich-click,
  uv,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "abx-plugins";
  version = "1.10.96";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    pname = "abx_plugins";
    inherit (finalAttrs) version;
    hash = "sha256-G740EuDXx6v8oiDAcdgNMjbqkFlP4nBrzRdz4nlRILI=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    abxbus
    abxpkg
    jambo
    rich-click
    uv
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
