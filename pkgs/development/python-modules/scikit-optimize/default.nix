{ lib
, isPy27
, buildPythonPackage
, fetchFromGitHub
, matplotlib
, numpy
, scipy
, scikitlearn
, pyaml
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "scikit-optimize";
  version = "0.8.1";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "scikit-optimize";
    repo = "scikit-optimize";
    rev = "v${version}";
    sha256 = "1bz8gxccx8n99abw49j8h5zf3i568g5hcf8nz1yinma8jqhxjkjh";
  };

  propagatedBuildInputs = [
    matplotlib
    numpy
    scipy
    scikitlearn
    pyaml
  ];

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Sequential model-based optimization toolbox";
    homepage = "https://scikit-optimize.github.io/";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
