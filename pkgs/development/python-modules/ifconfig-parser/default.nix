{ lib, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "ifconfig-parser";
  version = "0.0.5";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "KnightWhoSayNi";
    repo = pname;
    rev = "4921ac9d6be6244b062d082c164f5a5e69522478";
    sha256 = "07hbkbr1qspr7qgzldkaslzc6ripj5zlif12d4fk5j801yhvnxjd";
  };

  checkPhase = ''
    export PYTHONPATH=$PYTHONPATH:$(pwd)/ifconfigparser:$(pwd)/ifconfigparser/tests
    python -m unittest -v test_ifconfig_parser.TestIfconfigParser
  '';

  meta = with lib; {
    description = "Unsophisticated python package for parsing raw output of ifconfig.";
    homepage = "https://github.com/KnightWhoSayNi/ifconfig-parser";
    license = licenses.mit;
    maintainers = with maintainers; [ atemu ];
  };
}
