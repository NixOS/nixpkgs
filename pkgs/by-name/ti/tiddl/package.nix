{
  fetchPypi,
  nix-update-script,
  python3Packages,
  lib,
  ...
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "tiddl";
  version = "3.4.4";
  src = fetchPypi {
    inherit (finalAttrs) pname version;
    sha256 = "sha256-ClCNY4VTpeSSaXVFm8qsKUOxfRDLaxppYZDzGaRihTo=";
  };

  pyproject = true;
  pythonImportsCheck = "tiddl";
  build-system = [ python3Packages.uv ];
  nativeBuildInputs = with python3Packages; [
    setuptools
    uv
  ];

  propagatedBuildInputs = with python3Packages; [
    aiofiles
    aiohttp
    m3u8
    mutagen
    pydantic
    requests
    requests-cache
    typer
  ];

  env = {
    UV_NO_MANAGED_PYTHON = "1";
    UV_SYSTEM_PYTHON = true;
    UV_PYTHON_DOWNLOADS = "never";
    UV_OFFLINE = "1";
  };

  strictDeps = true;
  __structuredAttrs = true;
  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/oskvr37/tiddl";
    description = "Download tracks and videos from Tidal with max quality.";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.yuri-becker ];
    platforms = lib.platforms.all;
    mainProgram = "tiddl";
  };
})
