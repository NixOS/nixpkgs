{
  lib,
  buildPythonPackage,
  fetchPypi,
  pdm-backend,
  abxbus,
  abxpkg,
  abx-plugins,
  jambo,
  pydantic,
  pydantic-settings,
  platformdirs,
  requests,
  psutil,
  rich,
  rich-click,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "abx-dl";
  version = "1.10.96";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    pname = "abx_dl";
    inherit (finalAttrs) version;
    hash = "sha256-QIXPCznxS7jAfnam7PziWIkaOH1ukDYNcIPqdWMYQzg=";
  };

  build-system = [
    pdm-backend
  ];

  dependencies = [
    abxbus
    abxpkg
    abx-plugins
    jambo
    pydantic
    pydantic-settings
    platformdirs
    requests
    psutil
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
