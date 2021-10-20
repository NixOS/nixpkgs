{ lib
, buildPythonPackage
, fetchPypi
, aflplusplus
}:

buildPythonPackage rec {
  pname = "bsdiff4";
  version = "1.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "87cffc7522effdda03fd1564b212ad2279c0af50d16c3e65776f80acb6705d4b";
  };

  checkPhase = ''
    mv bsdiff4 _bsdiff4
    python -c 'import bsdiff4; bsdiff4.test()'
  '';

  meta = with lib; {
    description = "binary diff and patch using the BSDIFF4-format";
    homepage = "https://github.com/ilanschnell/bsdiff4";
    license = licenses.bsdProtection;
    maintainers = with maintainers; [ ris ];
  };
}
