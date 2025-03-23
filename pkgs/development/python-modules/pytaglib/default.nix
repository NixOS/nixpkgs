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
  version = "3.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "supermihi";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-TP3XScPDXlEnSR/BKcbF+DLt3rv8eyHrGwaBPAjIfA8=";
  };

  buildInputs = [
    cython
    taglib
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "taglib" ];

  meta = with lib; {
    description = "Python bindings for the Taglib audio metadata library";
    mainProgram = "pyprinttags";
    homepage = "https://github.com/supermihi/pytaglib";
    changelog = "https://github.com/supermihi/pytaglib/blob/${src.tag}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mrkkrp ];
  };
}
