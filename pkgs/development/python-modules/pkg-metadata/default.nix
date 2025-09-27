{
  flit-core,
  lib,
  buildPythonPackage,
  pytestCheckHook,
  git,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "pkg-metadata";
  version = "0.3";
  format = "pyproject";

  src = fetchFromGitHub {
    tag = version;
    owner = "pfmoore";
    repo = "pkg_metadata";
    sha256 = "sha256-F19Xjy1VJnoonyZThXMplsUvuoqKnxl0k5+fm0tQp/k=";
  };

  buildInputs = [ flit-core ];

  nativeCheckInputs = [
    git
    pytestCheckHook
  ];
  disabledTestPaths = [
    "manual_test.py"
  ];

  meta = {
    description = "Manage Python package metadata";
    homepage = "https://github.com/pfmoore/pkg_metadata";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yajo ];
  };
}
