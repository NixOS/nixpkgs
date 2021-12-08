{ lib, buildPythonPackage, isPy27, fetchFromGitHub, pytest, pytestCheckHook }:

buildPythonPackage rec {
  version = "0.2.0";
  pname = "ci-info";

  disabled = isPy27;

  src = fetchFromGitHub {
     owner = "mgxd";
     repo = "ci-info";
     rev = "0.2.0";
     sha256 = "1z40pbpbcsqbxnldgggpi94c5gp9azf3b2c68nfjww13m1qizsdm";
  };

  checkInputs = [ pytest pytestCheckHook ];

  doCheck = false;  # both tests access network

  pythonImportsCheck = [ "ci_info" ];

  meta = with lib; {
    description = "Gather continuous integration information on the fly";
    homepage = "https://github.com/mgxd/ci-info";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
