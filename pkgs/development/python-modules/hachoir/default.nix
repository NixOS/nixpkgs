{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  urwid,
}:

buildPythonPackage rec {
  pname = "hachoir";
  version = "3.4.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "vstinner";
    repo = "hachoir";
    tag = version;
    hash = "sha256-K4spxgaGasouOBK5uwcogCFBY7W7a5uR+TkkuH6QISM=";
  };

  propagatedBuildInputs = [ urwid ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "hachoir" ];

  meta = {
    description = "Python library to view and edit a binary stream";
    homepage = "https://hachoir.readthedocs.io/";
    changelog = "https://github.com/vstinner/hachoir/blob/${version}/doc/changelog.rst";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
