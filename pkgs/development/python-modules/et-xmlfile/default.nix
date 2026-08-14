{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  fetchpatch,
  lxml,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "et-xmlfile";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "foss.heptapod.net";
    owner = "openpyxl";
    repo = "et_xmlfile";
    tag = version;
    hash = "sha256-JZ1fJ9o4/Z+9uSlaoq+pNpLSwl5Yv6BJCI1G7GOaQ1I=";
  };

  patches = [
    (fetchpatch {
      # python 3.14 compat
      url = "https://foss.heptapod.net/openpyxl/et_xmlfile/-/commit/73172a7ce6d819ce13e6706f9a1c6d50f1646dde.patch";
      hash = "sha256-PMtzIGtXJ/vp0VRmBodvyaG/Ptn2DwrTTC1EyLSChHU=";
    })
  ];

  build-system = [ setuptools ];

  nativeCheckInputs = [
    lxml
    pytestCheckHook
  ];

  pythonImportsCheck = [ "et_xmlfile" ];

  meta = {
    description = "Implementation of lxml.xmlfile for the standard library";
    longDescription = ''
      et_xmlfile is a low memory library for creating large XML files.

      It is based upon the xmlfile module from lxml with the aim of
      allowing code to be developed that will work with both
      libraries. It was developed initially for the openpyxl project
      but is now a standalone module.
    '';
    homepage = "https://foss.heptapod.net/openpyxl/et_xmlfile";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
