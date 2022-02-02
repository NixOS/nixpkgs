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
  version = "0.0.7";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "mtdcr";
    repo = pname;
    rev = version;
    sha256 = "sha256-h8rQOKZozioZ7HmPETC5wBJyz7rMH1Q2wL6lF8G3zQU=";
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
