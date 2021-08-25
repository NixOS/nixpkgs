{ lib
, buildPythonPackage
, capstone
, click
, cryptography
, fetchFromGitHub
, pefile
, pycryptodomex
, pyelftools
, pythonOlder
, typing-extensions
, yara-python
}:

buildPythonPackage rec {
  pname = "malduck";
  version = "4.1.0";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = pname;
    rev = "v${version}";
    sha256 = "04d8bhzax9ynbl83hif9i8gcs29zrvcay2r6n7mcxiixlxcqciak";
  };

  propagatedBuildInputs = [
    capstone
    click
    cryptography
    pefile
    pycryptodomex
    pyelftools
    typing-extensions
    yara-python
  ];

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "pefile==2019.4.18" "pefile"
  '';

  # Project has no tests. They will come with the next release
  doCheck = false;

  pythonImportsCheck = [ "malduck" ];

  meta = with lib; {
    description = "Helper for malware analysis";
    homepage = "https://github.com/CERT-Polska/malduck";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
