{
  lib,
  angr,
  buildPythonPackage,
  fetchFromGitHub,
  progressbar,
  pythonOlder,
  setuptools,
  tqdm,
}:

buildPythonPackage rec {
  pname = "angrop";
  version = "9.2.10";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "angr";
    repo = "angrop";
    rev = "refs/tags/v${version}";
    hash = "sha256-+epX+tCSv5Kit4lncDNtjokehCSl+tO7rbi3L+RrI+E=";
  };

  build-system = [ setuptools ];

  dependencies = [
    angr
    progressbar
    tqdm
  ];

  # Tests have additional requirements, e.g., angr binaries
  # cle is executing the tests with the angr binaries already and is a requirement of angr
  doCheck = false;

  pythonImportsCheck = [ "angrop" ];

  meta = with lib; {
    description = "ROP gadget finder and chain builder";
    homepage = "https://github.com/angr/angrop";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ fab ];
  };
}
