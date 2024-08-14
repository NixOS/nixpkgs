{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pyflic";
  version = "2.0.3";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "soldag";
    repo = pname;
    rev = version;
    sha256 = "0adf4k191138jmbsfhkhhbgaxcq97d1hr5w48ryxr1fig64sjqy2";
  };

  # Projec thas no tests
  doCheck = false;

  pythonImportsCheck = [ "pyflic" ];

  meta = with lib; {
    description = "Python module to interact with Flic buttons";
    homepage = "https://github.com/soldag/pyflic";
    license = with licenses; [ cc0 ];
    maintainers = with maintainers; [ fab ];
  };
}
