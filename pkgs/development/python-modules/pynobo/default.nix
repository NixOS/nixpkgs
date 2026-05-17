{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pynobo";
  version = "1.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "echoromeo";
    repo = "pynobo";
    tag = "v${version}";
    hash = "sha256-7saIhGkcRkT+HATpnL+DcIWarZue7UCp1lTyfgzLfl8=";
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
