{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, tkinter
}:

buildPythonPackage rec {
  pname = "guppy3";
  version = "3.1.4.post1";
  format = "setuptools";
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "zhuyifei1999";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-HHy57P6WEHZKygAbdjEh6XAApFlQueiYGr02eSQMWfc=";
  };

  propagatedBuildInputs = [ tkinter ];

  # Tests are starting a Tkinter GUI
  doCheck = false;
  pythonImportsCheck = [ "guppy" ];

  meta = with lib; {
    description = "Python Programming Environment & Heap analysis toolset";
    homepage = "https://zhuyifei1999.github.io/guppy3/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
