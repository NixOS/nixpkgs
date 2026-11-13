{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pynobo";
  version = "1.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "echoromeo";
    repo = "pynobo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MXJC8H8ACVtcccQzan6X1INSspBF7rU/K5rWe+TpzKQ=";
  };

  build-system = [ setuptools ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pynobo" ];

  meta = {
    description = "Python TCP/IP interface for Nobo Hub/Nobo Energy Control devices";
    homepage = "https://github.com/echoromeo/pynobo";
    changelog = "https://github.com/echoromeo/pynobo/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fab ];
  };
})
