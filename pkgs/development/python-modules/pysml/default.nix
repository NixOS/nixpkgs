{ lib
, async-timeout
, bitstring
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pyserial-asyncio
}:

buildPythonPackage rec {
  pname = "pysml";
  version = "0.0.10";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "mtdcr";
    repo = pname;
    rev = version;
    hash = "sha256-vC4iff38WCcdUQITPmxC0XlrA83zCNLTDGgyyXivLEY=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

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
