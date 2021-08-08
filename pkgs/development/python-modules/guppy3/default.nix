{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, tkinter
}:

buildPythonPackage rec {
  pname = "guppy3";
  version = "3.1.1";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "zhuyifei1999";
    repo = pname;
    rev = "v${version}";
    sha256 = "14iwah1i4dcn74zjj9sq3av1yh9q5nvgqwccnn71blp7gxcnxnvh";
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
