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
  version = "4.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-UgpblcZ/Jxl3U4256YIHzly7igNXwhTdFN4HOqZBVbM=";
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

  pythonImportsCheck = [
    "malduck"
  ];

  meta = with lib; {
    description = "Helper for malware analysis";
    homepage = "https://github.com/CERT-Polska/malduck";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
