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
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "zhubonan";
    repo = "castepxbin";
    rev = "v${version}";
    sha256 = "0bqicpdyisbcz8argy4ppm59zzkcn9lcs4y1mh2f31f75x732na3";
  };

  propagatedBuildInputs = [
    numpy
    scipy
    pymatgen
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "A collection of readers for CASTEP binary outputs";
    homepage = "https://github.com/zhubonan/castepxbin";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
