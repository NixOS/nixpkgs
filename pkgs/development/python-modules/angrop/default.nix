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
  version = "9.2.9";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "angr";
    repo = "angrop";
    rev = "refs/tags/v${version}";
    hash = "sha256-T07Y23UDp9eL2DK5gakV8kPNGsXf+4EofZJDSW/JS1Q=";
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
