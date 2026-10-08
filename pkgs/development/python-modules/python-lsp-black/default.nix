{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  black,
  fetchpatch,

  # build-system
  setuptools,

  # dependencies
  python-lsp-server,

  # checks
  pytestCheckHook,
  setuptools_80,
}:

buildPythonPackage rec {
  pname = "python-lsp-black";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-lsp";
    repo = "python-lsp-black";
    tag = "v${version}";
    hash = "sha256-nV6mePSWzfPW2RwXg/mxgzfT9wD95mmTuPnPEro1kEY=";
  };

  patches = [
    # includes a series of patches fixing tests not yet released as 2.0.1+ version
    # they are meant to keep up to date with black releases
    (fetchpatch {
      url = "https://github.com/python-lsp/python-lsp-black/commit/d43b41431379f9c9bb05fab158c4d97e6d515f8f.patch";
      hash = "sha256-38bYU27+xtA8Kq3appXTkNnkG5/XgrUJ2nQ5+yuSU2U=";
    })
    (fetchpatch {
      url = "https://github.com/python-lsp/python-lsp-black/commit/9298585a9d14d25920c33b188d79e820dc98d4a9.patch";
      hash = "sha256-4u0VIS7eidVEiKRW2wc8lJVkJwhzJD/M+uuqmTtiZ7E=";
    })
    # https://github.com/python-lsp/python-lsp-black/pull/65 (black >= 26.5)
    (fetchpatch {
      url = "https://github.com/python-lsp/python-lsp-black/commit/35b5bc6f944bddac0c896127dc44a9404e95f482.patch";
      hash = "sha256-FRxM8leFVkPjRiR3wNjy5g5BazHc6ZvtnoI8Qgz4co4=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    black
    python-lsp-server
  ];

  pythonImportsCheck = [ "pylsp_black" ];

  nativeCheckInputs = [
    pytestCheckHook
    setuptools_80 # for pkg_resources, removed in setuptools 81+ (tests/test_plugin.py)
  ];

  meta = {
    homepage = "https://github.com/python-lsp/python-lsp-black";
    description = "Black plugin for the Python LSP Server";
    changelog = "https://github.com/python-lsp/python-lsp-black/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cpcloud ];
  };
}
