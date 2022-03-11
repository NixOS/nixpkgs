{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "bsdiff4";
  version = "1.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-GICsP1KmxGrmvMbbEX5Ps1+bDM1a91/U/uaQfQDWmDw=";
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
