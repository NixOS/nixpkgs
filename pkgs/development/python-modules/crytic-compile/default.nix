{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder, pysha3 }:

buildPythonPackage rec {
  pname = "crytic-compile";
  version = "0.1.9";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "crytic";
    repo = "crytic-compile";
    rev = version;
    sha256 = "01mis7bqsh0l5vjl6jwibzy99djza35fxmywy56q8k4jbxwmdcna";
  };

  propagatedBuildInputs = [ pysha3 ];

  doCheck = false;

  meta = with lib; {
    description = "Abstraction layer for smart contract build systems";
    homepage = "https://github.com/crytic/crytic-compile";
    license = licenses.agpl3;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
