{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "oasatelematics";
  version = "0.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "panosmz";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-3O7XbNVj1S3ZwheklEhm0ivw16Tj7drML/xYC9383Kg=";
  };

  propagatedBuildInputs = [ requests ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "oasatelematics" ];

  meta = with lib; {
    description = "Python wrapper for the OASA Telematics API";
    homepage = "https://github.com/panosmz/oasatelematics";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
