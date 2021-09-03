{ lib
, buildPythonPackage
, fetchPypi
, lief
, pythonOlder
}:

buildPythonPackage rec {
  pname = "autoit-ripper";
  version = "1.0.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0mbsrfa72n7y1vkm9jhwhn1z3k45jxrlgx58ia1l2bp6chnnn2zy";
  };

  propagatedBuildInputs = [
    lief
  ];

  postPatch = ''
    substituteInPlace requirements.txt --replace "lief==0.10.1" "lief>=0.10.1"
  '';

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "autoit_ripper" ];

  meta = with lib; {
    description = "Python module to extract AutoIt scripts embedded in PE binaries";
    homepage = "https://github.com/nazywam/AutoIt-Ripper";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
