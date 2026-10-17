{
  lib,
  buildPythonPackage,
  fetchPypi,
  pdm-backend,
  abxbus,
  abxpkg,
  abx-plugins,
  pydantic,
  pydantic-settings,
  platformdirs,
  requests,
  psutil,
  rich,
  rich-click,
  pytestCheckHook,
}:

let
  psutilForAbxDl =
    if lib.versionAtLeast psutil.version "7.2.1" && psutil.version != "7.2.2" then
      psutil
    else
      psutil.overridePythonAttrs (oldAttrs: rec {
        version = "7.2.1";
        src = fetchPypi {
          pname = oldAttrs.pname;
          inherit version;
          hash = "sha256-91g67FkEhbQ8pgHdnOoNzWW9e7IdMO9N2/Tqa17RvdM=";
        };
        meta = oldAttrs.meta // {
          changelog = "https://github.com/giampaolo/psutil/blob/release-${version}/HISTORY.rst";
        };
      });
in

buildPythonPackage (finalAttrs: {
  pname = "abx-dl";
  version = "1.13.127";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    pname = "abx_dl";
    inherit (finalAttrs) version;
    hash = "sha256-rWGkhy2i/dK7ToMPWduMggpvZz45oAYf1ybaKrPHrrw=";
  };

  build-system = [
    pdm-backend
  ];

  dependencies = [
    abxbus
    abxpkg
    abx-plugins
    pydantic
    pydantic-settings
    platformdirs
    requests
    psutilForAbxDl
    rich
    rich-click
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # Tests invoke live network requests to download URLs for archiving
  doCheck = false;

  # abx_dl.config creates its CONFIG_DIR at import time; needs a writable HOME
  env.HOME = "/tmp";

  pythonImportsCheck = [ "abx_dl" ];

  meta = {
    changelog = "https://github.com/ArchiveBox/abx-dl/releases";
    description = "One-shot CLI downloader powered by the ArchiveBox plugin ecosystem";
    homepage = "https://github.com/ArchiveBox/abx-dl";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ philocalyst ];
    mainProgram = "abx-dl";
  };
})
