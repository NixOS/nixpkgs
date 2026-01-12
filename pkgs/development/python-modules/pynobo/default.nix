{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pynobo";
  version = "1.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "echoromeo";
    repo = "pynobo";
    tag = "v${version}";
    hash = "sha256-OSgpT9CLkfnv1BLAJApZUs3vMc1WE2eG7ZrinCLy/0U=";
  };

  build-system = [ setuptools ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pynobo" ];

  meta = {
    description = "Python TCP/IP interface for Nobo Hub/Nobo Energy Control devices";
    homepage = "https://github.com/echoromeo/pynobo";
    changelog = "https://github.com/echoromeo/pynobo/releases/tag/v${version}";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
