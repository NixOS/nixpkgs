{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, capstone
, filebytes
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "ropper";
  version = "1.13.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sashs";
    repo = "Ropper";
    rev = "v${version}";
    hash = "sha256-3tWWIYqh/G/b7Z6BMua5bRvtSh4SibT6pv/NArhmqPE=";
  };

  propagatedBuildInputs = [
    capstone
    filebytes
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "ropper"
  ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Show information about files in different file formats";
    homepage = "https://scoding.de/ropper/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bennofs ];
  };
}
