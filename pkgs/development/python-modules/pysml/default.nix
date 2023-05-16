{ lib
, async-timeout
, bitstring
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pyserial-asyncio
<<<<<<< HEAD
, pythonOlder
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "pysml";
<<<<<<< HEAD
  version = "0.0.12";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mtdcr";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-DgfTSlgDC92l/hOgrMZrkZi1wzRUDY8tNl4xU3OQgJ8=";
=======
  version = "0.0.10";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "mtdcr";
    repo = pname;
    rev = version;
    hash = "sha256-vC4iff38WCcdUQITPmxC0XlrA83zCNLTDGgyyXivLEY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
  pythonImportsCheck = [
    "sml"
  ];
=======
  pythonImportsCheck = [ "sml" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Python library for EDL21 smart meters using Smart Message Language (SML)";
    homepage = "https://github.com/mtdcr/pysml";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
