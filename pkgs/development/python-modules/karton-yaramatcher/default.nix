{ lib
, buildPythonPackage
, fetchFromGitHub
, karton-core
, python
, yara-python
}:

buildPythonPackage rec {
  pname = "karton-yaramatcher";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = pname;
    rev = "v${version}";
    sha256 = "0yb9l5z826zli5cpcj234dmjdjha2g1lcwxyvpxm95whkhapc2cf";
  };

  propagatedBuildInputs = [
    karton-core
    yara-python
  ];

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "karton-core==4.0.5" "karton-core" \
      --replace "yara-python==4.0.2" "yara-python" \
  '';

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
