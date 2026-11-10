{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  fspath,
  docutils,
  sphinx,
}:

buildPythonPackage (finalAttrs: {
  pname = "linuxdoc";
  version = "20240924";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "return42";
    repo = "linuxdoc";
    tag = finalAttrs.version;
    hash = "sha256-UOOIl+HWI7bK6iWrADTgrGvom++178yPYmyI+qTwVlg=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    fspath
    docutils
    sphinx
  ];

  pythonImportsCheck = [ "linuxdoc" ];

  meta = {
    description = "Sphinx-doc extensions for sophisticated C developer";
    homepage = "https://github.com/return42/linuxdoc";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ skohtv ];
  };
})
