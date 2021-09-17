{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, scipy
, pymatgen
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "castepxbin";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "zhubonan";
    repo = "castepxbin";
    rev = "v${version}";
    sha256 = "16wnd1mwhl204d1s3har2fhyhyjg86sypg00bj812dxk8zixxszf";
  };

  propagatedBuildInputs = [
    numpy
    scipy
    pymatgen
  ];

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "A collection of readers for CASTEP binary outputs";
    homepage = "https://github.com/zhubonan/castepxbin";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
