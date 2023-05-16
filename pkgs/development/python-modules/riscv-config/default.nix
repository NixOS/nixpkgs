<<<<<<< HEAD
{ lib
, buildPythonPackage
, cerberus
, fetchFromGitHub
, fetchpatch
, pythonOlder
=======
{ buildPythonPackage
, fetchFromGitHub
, lib
, cerberus
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pyyaml
, ruamel-yaml
}:

buildPythonPackage rec {
  pname = "riscv-config";
<<<<<<< HEAD
  version = "3.13.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";
=======
  version = "3.5.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "riscv-software-src";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-SnUt6bsTEC7abdQr0nWyNOAJbW64B1K3yy1McfkdxAc=";
  };

  propagatedBuildInputs = [
    cerberus
    pyyaml
    ruamel-yaml
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "riscv_config"
  ];

  meta = with lib; {
    description = "RISC-V configuration validator";
    homepage = "https://github.com/riscv/riscv-config";
    changelog = "https://github.com/riscv-software-src/riscv-config/blob/${version}/CHANGELOG.md";
=======
    hash = "sha256-K7W6yyqy/2c4WHyOojuvw2P/v7bND5K6WFfTujkofBw=";
  };

  propagatedBuildInputs = [ cerberus pyyaml ruamel-yaml ];

  meta = with lib; {
    homepage = "https://github.com/riscv/riscv-config";
    description = "RISC-V configuration validator";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ genericnerdyusername ];
    license = licenses.bsd3;
  };
}
