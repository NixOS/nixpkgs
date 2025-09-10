{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pyflic";
  version = "2.0.4";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "soldag";
    repo = "pyflic";
    rev = version;
    sha256 = "sha256-K1trMBZfc1aHSNSddq0v//Gv8ySgT/ONQYgrKWzw2qs=";
  };

  # Project thas no tests
  doCheck = false;

  pythonImportsCheck = [ "pyflic" ];

  meta = with lib; {
    description = "Python module to interact with Flic buttons";
    homepage = "https://github.com/soldag/pyflic";
    license = with licenses; [ cc0 ];
    maintainers = with maintainers; [ fab ];
  };
}
