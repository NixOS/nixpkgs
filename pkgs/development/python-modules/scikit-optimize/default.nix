{ lib
, isPy27
, buildPythonPackage
, fetchFromGitHub
, matplotlib
, numpy
, scipy
, scikit-learn
, pyaml
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "scikit-optimize";
  version = "0.9.0";
  format = "setuptools";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "scikit-optimize";
    repo = "scikit-optimize";
    rev = "v${version}";
    sha256 = "0hsq6pmryimxc275yrcy4bv217bx7ma6rz0q6m4138bv4zgq18d1";
  };

  propagatedBuildInputs = [
    matplotlib
    numpy
    scipy
    scikit-learn
    pyaml
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Sequential model-based optimization toolbox";
    homepage = "https://scikit-optimize.github.io/";
    license = licenses.bsd3;
    maintainers = [ ];
    broken = true; # It will fix by https://github.com/scikit-optimize/scikit-optimize/pull/1123
  };
}
