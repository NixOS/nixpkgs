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
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = pname;
    rev = "v${version}";
    sha256 = "0s09mzsw546klnvm59wzj9vdwd2hyzgxvapi20k86q3prs9ncds6";
  };

  propagatedBuildInputs = [
    chardet
    karton-core
    python_magic
  ];

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "chardet==3.0.4" "chardet" \
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
