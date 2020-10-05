{ lib
, buildPythonPackage
, fetchPypi
, param
, pyyaml
, requests
, pytest
}:

buildPythonPackage rec {
  pname = "pyct";
  version = "0.4.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "23d7525b5a1567535c093aea4b9c33809415aa5f018dd77f6eb738b1226df6f7";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [
    param
    pyyaml
    requests
  ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Cli for python common tasks for users";
    homepage = "https://github.com/pyviz/pyct";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
