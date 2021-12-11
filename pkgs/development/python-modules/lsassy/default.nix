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
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "Hackndo";
    repo = pname;
    rev = "v${version}";
    sha256 = "0xycpyzjbzr7836hjzcbmf7sri0r2az65yc6yrgy6kay0v75j4p6";
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
