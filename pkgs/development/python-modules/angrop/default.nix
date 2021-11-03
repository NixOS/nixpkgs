{ lib
, angr
, buildPythonPackage
, fetchFromGitHub
, progressbar
, pythonOlder
, tqdm
}:

buildPythonPackage rec {
  pname = "angrop";
  version = "9.0.10409";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "angr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-3PU+WA5718L2qDl0j3hDdMS1wxJG3jJlM0yPFWE3NJ4=";
  };

  propagatedBuildInputs = [
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
