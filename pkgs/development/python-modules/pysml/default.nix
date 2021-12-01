{ lib
, async-timeout
, bitstring
, buildPythonPackage
, fetchFromGitHub
, pyserial-asyncio
}:

buildPythonPackage rec {
  pname = "pysml";
  version = "0.0.5";

  src = fetchFromGitHub {
    owner = "mtdcr";
    repo = pname;
    rev = version;
    sha256 = "05zgrk49b2y5jflxnjww2kqg1flynl3j4ifm0jr28nk0li5wg2bs";
  };

  propagatedBuildInputs = [
    async-timeout
    bitstring
    pyserial-asyncio
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "sml" ];

  meta = with lib; {
    description = "Python library for EDL21 smart meters using Smart Message Language (SML)";
    homepage = "https://github.com/mtdcr/pysml";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
