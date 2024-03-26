{ lib
, pythonOlder
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, black
, python-lsp-server
, setuptools
, tomli
, fetchpatch
}:

buildPythonPackage rec {
  pname = "python-lsp-black";
  version = "2.0.0";
  pyproject = true;
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "python-lsp";
    repo = "python-lsp-black";
    rev = "refs/tags/v${version}";
    hash = "sha256-nV6mePSWzfPW2RwXg/mxgzfT9wD95mmTuPnPEro1kEY=";
  };

  patches =
    /** fix test failure with black<24.2.0;
        remove this patch once python-lsp-black>2.0.0 */
    lib.optional
      (with lib; (versionOlder version "2.0.1") && (versionAtLeast black.version "24.2.0"))
      (fetchpatch {
        url = "https://patch-diff.githubusercontent.com/raw/python-lsp/python-lsp-black/pull/56.patch";
        hash = "sha256-38bYU27+xtA8Kq3appXTkNnkG5/XgrUJ2nQ5+yuSU2U=";
      })
    ++ [ ];

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  propagatedBuildInputs = [
    black
    python-lsp-server
  ] ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ];

  pythonImportsCheck = [
    "pylsp_black"
  ];

  meta = with lib; {
    homepage = "https://github.com/python-lsp/python-lsp-black";
    description = "Black plugin for the Python LSP Server";
    changelog = "https://github.com/python-lsp/python-lsp-black/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
