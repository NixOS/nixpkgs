{ lib
, buildPythonPackage
, fetchFromGitHub
, karton-core
, python
, yara-python
}:

buildPythonPackage rec {
  pname = "karton-yaramatcher";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = pname;
    rev = "v${version}";
    sha256 = "0mv8v1gk6p21pw9kx6cxr76l6c5fxd3p6dk85cwfzz100h8mdvar";
  };

  propagatedBuildInputs = [
    karton-core
    yara-python
  ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m unittest discover
    runHook postCheck
  '';

  pythonImportsCheck = [ "karton.yaramatcher" ];

  meta = with lib; {
    description = "File and analysis artifacts yara matcher for the Karton framework";
    homepage = "https://github.com/CERT-Polska/karton-yaramatcher";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
