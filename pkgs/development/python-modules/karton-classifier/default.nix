{ lib
, buildPythonPackage
, chardet
, fetchFromGitHub
, karton-core
, python
, python_magic
}:

buildPythonPackage rec {
  pname = "karton-classifier";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = pname;
    rev = "v${version}";
    sha256 = "05pxv0smrzgmljykc6yx0rx8b85ck7fa09xjkjw0dd7lb6bb19a6";
  };

  propagatedBuildInputs = [
    chardet
    karton-core
    python_magic
  ];

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "chardet==3.0.4" "chardet" \
      --replace "karton-core==4.0.4" "karton-core" \
      --replace "python-magic==0.4.18" "python-magic"
  '';

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m unittest discover
    runHook postCheck
  '';

  pythonImportsCheck = [ "karton.classifier" ];

  meta = with lib; {
    description = "File type classifier for the Karton framework";
    homepage = "https://github.com/CERT-Polska/karton-classifier";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
