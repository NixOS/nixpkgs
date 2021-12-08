{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "colorlog";
  version = "6.6.0";

  src = fetchFromGitHub {
     owner = "borntyping";
     repo = "python-colorlog";
     rev = "v6.6.0";
     sha256 = "0sfs2alhhnjmxzgbqdhbh1ylykdcj9vkm7rs6i7xymsgpf26qinb";
  };

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "colorlog" ];

  meta = with lib; {
    description = "Log formatting with colors";
    homepage = "https://github.com/borntyping/python-colorlog";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
