{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pythonOlder,
}:

buildPythonPackage {
  pname = "ifconfig-parser";
  version = "0.0.5";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "KnightWhoSayNi";
    repo = "ifconfig-parser";
    rev = "4921ac9d6be6244b062d082c164f5a5e69522478";
    hash = "sha256-TXa7oQ8AyTIdaSK4SH+RN2bDPtVqNvofPvlqHPKaCx4=";
  };

  build-system = [ setuptools ];

  checkPhase = ''
    export PYTHONPATH=$PYTHONPATH:$(pwd)/ifconfigparser:$(pwd)/ifconfigparser/tests
    python -m unittest -v test_ifconfig_parser.TestIfconfigParser
  '';

  pythonImportsCheck = [ "ifconfigparser" ];

  meta = with lib; {
    description = "Module for parsing raw output of ifconfig";
    homepage = "https://github.com/KnightWhoSayNi/ifconfig-parser";
    license = licenses.mit;
    maintainers = with maintainers; [ atemu ];
  };
}
