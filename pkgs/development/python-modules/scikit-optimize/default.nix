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
<<<<<<< HEAD
    maintainers = [ ];
    broken = true; # It will fix by https://github.com/scikit-optimize/scikit-optimize/pull/1123
=======
    maintainers = [ maintainers.costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
