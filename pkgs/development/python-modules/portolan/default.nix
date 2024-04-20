{ lib, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "portolan";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "fitnr";
    repo = "portolan";
    rev = "v${version}";
    hash = "sha256-zKloFO7uCLkqgayxC11JRfMpNxIR+UkT/Xabb9AH8To=";
  };

  pythonImportsCheck = [ "portolan" ];

  meta = with lib; {
    homepage = "https://github.com/fitnr/portolan";
    description = "Convert between compass points and degrees";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ eliandoran ];
  };
}
