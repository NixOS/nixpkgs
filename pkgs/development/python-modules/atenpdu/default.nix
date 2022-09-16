{ lib
, buildPythonPackage
, fetchPypi
, async-timeout
, pysnmp
}:

buildPythonPackage rec {
  pname = "atenpdu";
  version = "0.3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-vvq8InmJUgvm/PpvZutpsBR3Fj1gR+xrkgfEGlw04Ek=";
  };

  propagatedBuildInputs = [
    async-timeout
    pysnmp
  ];

  # Project has no test
  doCheck = false;
  pythonImportsCheck = [ "atenpdu" ];

  meta = with lib; {
    description = "Python interface to control ATEN PE PDUs";
    homepage = "https://github.com/mtdcr/pductl";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
