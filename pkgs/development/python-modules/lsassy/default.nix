{ lib
, buildPythonPackage
, fetchFromGitHub
, impacket
, netaddr
, pypykatz
}:

buildPythonPackage rec {
  pname = "lsassy";
  version = "2.1.5";

  src = fetchFromGitHub {
    owner = "Hackndo";
    repo = pname;
    rev = "v${version}";
    sha256 = "15w12asy797dxsz57avbxy6dbi7va9p5jx6i3gm9df9mbj0j3lcc";
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
