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
  version = "1.13.8";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sashs";
    repo = "Ropper";
    rev = "v${version}";
    hash = "sha256-agbqP5O9QEP5UKkaWI5HxAlMsCBPKNSLnAAo2WFDXS8=";
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
    description = "Show information about files in different file formats";
    homepage = "https://scoding.de/ropper/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bennofs ];
    broken = stdenv.isDarwin;
  };
}
