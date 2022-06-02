{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, colorama
}:

buildPythonPackage rec {
  pname = "migen";
  version = "unstable-2021-09-14";
  disabled = pythonOlder "3.3";

  src = fetchFromGitHub {
    owner = "m-labs";
    repo = "migen";
    rev = "a5bc262560238f93ceaad423820eb06843326274";
    sha256 = "32UjaIam/B7Gx6XbPcR067LcXfokJH2mATG9mU38a6o=";
  };

  propagatedBuildInputs = [
    colorama
  ];

  pythonImportsCheck = [ "migen" ];

  meta = with lib; {
    description = " A Python toolbox for building complex digital hardware";
    homepage = "https://m-labs.hk/migen";
    license = licenses.bsd2;
    maintainers = with maintainers; [ l-as ];
  };
}
