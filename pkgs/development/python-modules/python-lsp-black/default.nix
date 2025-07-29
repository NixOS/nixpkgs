{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  black,
  fetchpatch,

  # build-system
  setuptools,

  # dependencies
  python-lsp-server,
  tomli,

  # checks
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "python-lsp-black";
  version = "2.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "python-lsp";
    repo = "python-lsp-black";
    tag = "v${version}";
    hash = "sha256-nV6mePSWzfPW2RwXg/mxgzfT9wD95mmTuPnPEro1kEY=";
  };

  patches =
    /**
      includes a series of patches fixing tests not yet released as 2.0.1+ version
       they are meant to keep up to date with black releases
    */
    lib.optional (lib.versionAtLeast black.version "24.2.0") (fetchpatch {
      url = "https://github.com/python-lsp/python-lsp-black/commit/d43b41431379f9c9bb05fab158c4d97e6d515f8f.patch";
      hash = "sha256-38bYU27+xtA8Kq3appXTkNnkG5/XgrUJ2nQ5+yuSU2U=";
    })
    ++ lib.optional (lib.versionAtLeast black.version "24.3.0") (fetchpatch {
      url = "https://github.com/python-lsp/python-lsp-black/commit/9298585a9d14d25920c33b188d79e820dc98d4a9.patch";
      hash = "sha256-4u0VIS7eidVEiKRW2wc8lJVkJwhzJD/M+uuqmTtiZ7E=";
    });

  build-system = [ setuptools ];

  dependencies = [
    black
    python-lsp-server
  ]
  ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  pythonImportsCheck = [ "pylsp_black" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    homepage = "https://github.com/python-lsp/python-lsp-black";
    description = "Black plugin for the Python LSP Server";
    changelog = "https://github.com/python-lsp/python-lsp-black/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cpcloud ];
  };
}
