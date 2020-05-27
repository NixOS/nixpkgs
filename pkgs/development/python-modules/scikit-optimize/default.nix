{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
, matplotlib
, numpy
, scipy
, scikitlearn
, pyaml
, pytest
}:

buildPythonPackage rec {
  pname = "scikit-optimize";
  version = "0.7.4";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "scikit-optimize";
    repo = "scikit-optimize";
    rev = "v${version}";
    sha256 = "1wjvcvlgan9gps70ghgj42y4v3lhp0r65rwpp1fs4impzqkaxsia";
  };

  propagatedBuildInputs = [
    matplotlib
    numpy
    scipy
    scikitlearn
    pyaml
  ];

  checkInputs = [
    pytest
  ];

  checkPhase = ''
    pytest skopt
  '';

  meta = with lib; {
    description = "Sequential model-based optimization toolbox";
    homepage = "https://scikit-optimize.github.io/";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
