{ lib
, buildPythonPackage
, fetchFromGitHub
, impacket
, netaddr
, pypykatz
, rich
}:

buildPythonPackage rec {
  pname = "lsassy";
  version = "3.0.3";

  src = fetchFromGitHub {
    owner = "Hackndo";
    repo = pname;
    rev = "v${version}";
    sha256 = "0mps9m7lg7mng4bdxk1rfayyz64flgdv0pxxa7gzvnr18kd1rbrz";
  };

  propagatedBuildInputs = [
    impacket
    netaddr
    pypykatz
    rich
  ];

  # Tests require an active domain controller
  doCheck = false;

  pythonImportsCheck = [
    "lsassy"
  ];

  meta = with lib; {
    description = "Python module to extract data from Local Security Authority Subsystem Service (LSASS)";
    homepage = "https://github.com/Hackndo/lsassy";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
