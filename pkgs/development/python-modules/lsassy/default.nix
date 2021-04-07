{ lib
, buildPythonPackage
, fetchFromGitHub
, impacket
, netaddr
, pypykatz
}:

buildPythonPackage rec {
  pname = "lsassy";
  version = "2.1.3";

  src = fetchFromGitHub {
    owner = "Hackndo";
    repo = pname;
    rev = "v${version}";
    sha256 = "1zig34ymc1h18gjc2ji0w0711im5sm9xm6nydc01c13yfpvvj1rh";
  };

  propagatedBuildInputs = [
    impacket
    netaddr
    pypykatz
  ];

  # Tests require an active domain controller
  doCheck = false;
  pythonImportsCheck = [ "lsassy" ];

  meta = with lib; {
    description = "Python module to extract data from Local Security Authority Subsystem Service (LSASS)";
    homepage = "https://github.com/Hackndo/lsassy";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
