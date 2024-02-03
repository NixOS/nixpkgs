{ lib
, buildPythonPackage
, fetchPypi
, pefile
, pythonOlder
}:

buildPythonPackage rec {
  pname = "autoit-ripper";
  version = "1.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-a30SDJdKoljWjV0O1sZ35NnQPFcJ0XOPcmTanozWpHY=";
  };

  propagatedBuildInputs = [
    pefile
  ];

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "pefile==2019.4.18" "pefile>=2019.4.18"
  '';

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "autoit_ripper"
  ];

  meta = with lib; {
    description = "Python module to extract AutoIt scripts embedded in PE binaries";
    homepage = "https://github.com/nazywam/AutoIt-Ripper";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
