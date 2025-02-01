{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  lxml,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "et-xmlfile";
  version = "1.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitLab {
    domain = "foss.heptapod.net";
    owner = "openpyxl";
    repo = "et_xmlfile";
    rev = version;
    hash = "sha256-MJimcnYKujOL3FedGreNpuw1Jpg48ataDmFd1qwTS5A=";
  };

  nativeCheckInputs = [
    lxml
    pytestCheckHook
  ];

  pythonImportsCheck = [ "et_xmlfile" ];

  meta = with lib; {
    description = "An implementation of lxml.xmlfile for the standard library";
    longDescription = ''
      et_xmlfile is a low memory library for creating large XML files.

      It is based upon the xmlfile module from lxml with the aim of
      allowing code to be developed that will work with both
      libraries. It was developed initially for the openpyxl project
      but is now a standalone module.
    '';
    homepage = "https://foss.heptapod.net/openpyxl/et_xmlfile";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
