{ lib
, angr
, buildPythonPackage
, fetchFromGitHub
, progressbar
, pythonOlder
, pythonRelaxDepsHook
, tqdm
}:

buildPythonPackage rec {
  pname = "angrop";
  version = "9.2.7";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "angr";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-wIPk7Cz7FSPviPFBSLrBjLr9M0o3pyoJM7wiAhHrg9Q=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    angr
    progressbar
    tqdm
  ];

  pythonRelaxDeps = [
    "angr"
  ];

  # Tests have additional requirements, e.g., angr binaries
  # cle is executing the tests with the angr binaries already and is a requirement of angr
  doCheck = false;

  pythonImportsCheck = [
    "angrop"
  ];

  meta = with lib; {
    description = "ROP gadget finder and chain builder";
    homepage = "https://github.com/angr/angrop";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ fab ];
  };
}
