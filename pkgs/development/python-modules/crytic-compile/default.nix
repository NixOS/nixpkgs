{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder, pysha3, setuptools }:

buildPythonPackage rec {
  pname = "crytic-compile";
  version = "0.2.2";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "crytic";
    repo = "crytic-compile";
    rev = version;
    sha256 = "sha256-4Lz+jJdKURp+K5XJJb7ksiFbnQwzS71gZWOufBvqz/k=";
  };

  propagatedBuildInputs = [ pysha3 setuptools ];

  doCheck = false;
  pythonImportsCheck = [ "crytic_compile" ];

  meta = with lib; {
    description = "Abstraction layer for smart contract build systems";
    homepage = "https://github.com/crytic/crytic-compile";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ SuperSandro2000 arturcygan ];
  };
}
