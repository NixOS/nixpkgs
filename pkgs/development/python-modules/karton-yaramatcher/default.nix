{ lib
, buildPythonPackage
, fetchFromGitHub
, karton-core
, python
, yara-python
}:

buildPythonPackage rec {
  pname = "karton-yaramatcher";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = pname;
    rev = "v${version}";
    sha256 = "093h5hbx2ss4ly523gvf10a5ky3vvin6wipigvhx13y1rdxl6c9n";
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
