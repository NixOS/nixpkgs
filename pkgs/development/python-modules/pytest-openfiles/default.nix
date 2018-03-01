{ lib, buildPythonPackage, fetchPypi, pytest, psutil }:

buildPythonPackage rec {
  pname = "pytest-openfiles";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "254d8a4326fa60c2532419c44932d529fb7172616ff126b154a09907d398d0b2";
  };

  propagatedBuildInputs = [ pytest psutil ];

  checkPhase = ''
    py.test --open-files
  '';

  meta = with lib; {
    description = "Pytest plugin for detecting inadvertent open file handles";
    homepage = https://github.com/astropy/pytest-openfiles;
    license = licenses.bsd3;
  };
}
