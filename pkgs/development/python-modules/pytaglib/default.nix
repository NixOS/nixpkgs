{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  taglib,
  cython,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pytaglib";
  version = "2.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "supermihi";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-b3ODsG5rdSJ1Tq/0DARf99gHgWWGaArBFAjqeK3mvsY=";
  };

  buildInputs = [
    cython
    taglib
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "taglib" ];

  # blocked on taglib 2.0, see
  # - https://github.com/NixOS/nixpkgs/pull/384003
  # - https://github.com/NixOS/nixpkgs/pull/373837
  passthru.skipBulkUpdate = true;

  meta = with lib; {
    description = "Python bindings for the Taglib audio metadata library";
    mainProgram = "pyprinttags";
    homepage = "https://github.com/supermihi/pytaglib";
    changelog = "https://github.com/supermihi/pytaglib/blob/${src.tag}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mrkkrp ];
  };
}
