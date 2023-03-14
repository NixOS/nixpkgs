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
  version = "0.0.9";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "mtdcr";
    repo = pname;
    rev = version;
    sha256 = "sha256-pUbRttH/ksYcE1qZJAQWhuKk4+40w5xsul0TTqq1g3s=";
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
