{ lib
, buildPythonPackage
, fetchFromBitbucket
, isPy27
, pytest
, jdcal
, et_xmlfile
, lxml
, pillow
}:

buildPythonPackage rec {
  pname = "openpyxl";
  version = "3.0.1";
  disabled = isPy27; # 2.6.4 was final python2 release

  src = fetchFromBitbucket {
    owner = "openpyxl";
    repo = pname;
    rev = version;
    sha256 = "1svmnzby6sfdv1qkb1va8z8krysrcdzfjibnyzvl8jgpydcvi8v5";
  };

  checkInputs = [
    pytest
    pillow
  ];

  propagatedBuildInputs = [
    jdcal
    et_xmlfile
    lxml
  ];

  checkPhase = ''
    pytest openpyxl
  '';

  meta = {
    description = "A Python library to read/write Excel 2010 xlsx/xlsm/xltx/xltm files";
    homepage = https://openpyxl.readthedocs.org;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lihop sjourdois ];
  };
}
