{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  uv-build,
  bibtexparser,
  click,
  feedparser,
  httpx,
  mcp,
  whenever,
  pythonOlder,
}:
buildPythonPackage (finalAttrs: {
  pname = "pyzotero";
  version = "1.10.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "urschrei";
    repo = "pyzotero";
    tag = "v${finalAttrs.version}";
    hash = "sha256-61FvzGUd0cThYu8LxhZO+ChTywTgkYtuXo4DBJpxT1A=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.8.14,<0.9.0" "uv_build"

    # Remove entrypoints that depend on optional dependencies (click, mcp)
    # to avoid ModuleNotFoundError at runtime
    substituteInPlace pyproject.toml \
      --replace-fail 'pyzotero = "pyzotero.cli:main"' "" \
      --replace-fail 'pyzotero-mcp = "pyzotero.mcp_server:main"' ""
  '';

  build-system = [ uv-build ];

  dependencies = [
    bibtexparser
    feedparser
    httpx
    whenever
  ];

  optional-dependencies = {
    cli = [ click ];
    mcp = [ mcp ];
  };

  # Tests require network access (Zotero API)
  doCheck = false;

  pythonImportsCheck = [ "pyzotero" ];

  meta = {
    description = "Pyzotero: a Python client for the Zotero API";
    homepage = "https://github.com/urschrei/pyzotero";
    changelog = "https://github.com/urschrei/pyzotero/blob/${finalAttrs.src.tag}/CHANGES.md";
    license = lib.licenses.blueOak100;
    maintainers = with lib.maintainers; [ mulatta ];
  };
})
