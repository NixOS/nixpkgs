{ lib, buildPythonPackage, fetchFromGitHub, crcmod, pytestCheckHook }:

buildPythonPackage rec {
  pname = "ndspy";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "RoadrunnerWMC";
    repo = pname;
    rev = "v${version}";
    sha256 = "0x3sp10had1mq192m7kgjivvs8kpjagxjgj9d4z95dfjhzzbjh70";
  };

  propagatedBuildInputs = [ crcmod ];
  checkInputs = [ pytestCheckHook ];
  preCheck = "cd tests";

  meta = with lib; {
    homepage = "https://github.com/RoadrunnerWMC/ndspy";
    description = "A Python library for many Nintendo DS file formats";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ xfix ];
  };
}
