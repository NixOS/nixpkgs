{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "bsdiff4";
  version = "1.2.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GICsP1KmxGrmvMbbEX5Ps1+bDM1a91/U/uaQfQDWmDw=";
  };

  pythonImportsCheck = [
    "bsdiff4"
  ];

  checkPhase = ''
    mv bsdiff4 _bsdiff4
    python -c 'import bsdiff4; bsdiff4.test()'
  '';

  meta = with lib; {
    description = "Binary diff and patch using the BSDIFF4-format";
    homepage = "https://github.com/ilanschnell/bsdiff4";
    license = licenses.bsdProtection;
    maintainers = with maintainers; [ ris ];
  };
}
