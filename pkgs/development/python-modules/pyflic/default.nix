{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "pyflic";
  version = "2.0.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "soldag";
    repo = "pyflic";
    rev = version;
    sha256 = "sha256-K1trMBZfc1aHSNSddq0v//Gv8ySgT/ONQYgrKWzw2qs=";
  };

  # Project thas no tests
  doCheck = false;

  pythonImportsCheck = [ "pyflic" ];

  meta = {
    description = "Python module to interact with Flic buttons";
    homepage = "https://github.com/soldag/pyflic";
    license = with lib.licenses; [ cc0 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
