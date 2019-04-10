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
  version = "0.4.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "df7b2d29f874cabdbc22e4f8cba2ceb895c48aa33da4e0fe679e89873e0a4c6e";
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
    homepage = https://github.com/pyviz/pyct;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
