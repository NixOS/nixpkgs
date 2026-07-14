{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  urwid,
}:

buildPythonPackage rec {
  pname = "hachoir";
  version = "3.3.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "vstinner";
    repo = "hachoir";
    tag = version;
    hash = "sha256-sTUJx8Xyhw4Z6juRtREw/okuVjSTSVWpSLKeZ7T8IR8=";
  };

  propagatedBuildInputs = [ urwid ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "hachoir" ];

  meta = {
    description = "Python library to view and edit a binary stream";
    homepage = "https://hachoir.readthedocs.io/";
    changelog = "https://github.com/vstinner/hachoir/blob/${version}/doc/changelog.rst";
    license = with lib.licenses; [ gpl2Only ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
