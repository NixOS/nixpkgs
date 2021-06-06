{ buildPythonPackage, isPy27, fetchFromGitHub, lib, ipaddress }:

buildPythonPackage rec {
  pname = "piccata";
  version = "2.0.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "NordicSemiconductor";
    repo = pname;
    rev = version;
    sha256 = "0pn842jcf2czjks5dphivgp1s7wiifqiv93s0a89h0wxafd6pbsr";
  };

  propagatedBuildInputs = [
    ipaddress
  ];

  pythonImportsCheck = [ "piccata" ];

  meta = {
    description = "Simple CoAP (RFC7252) toolkit";
    homepage = "https://github.com/NordicSemiconductor/piccata";
    maintainers = with lib.maintainers; [ gebner ];
  };
}
