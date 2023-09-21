{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, tkinter
}:

buildPythonPackage rec {
  pname = "guppy3";
  version = "3.1.3";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "zhuyifei1999";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-i3WqXlNnNhBVw9rdnxnzQISFkZHBpc/gqG+rxOWPiyc=";
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
