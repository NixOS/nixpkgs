{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  setuptools,

  joblib,
  pyaml,
  numpy,
  scipy,
  scikit-learn,
  packaging,
}:

buildPythonPackage rec {
  pname = "scikit-optimize";
  version = "0.10.2";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "holgern";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-C/0JqPiYgNegoH0v36cSvSgAo6pjb1nqFIOi3/9Whl0=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    joblib
    pyaml
    numpy
    scipy
    scikit-learn
    packaging
  ];

  pythonImportsCheck = [ "skopt" ];

  meta = with lib; {
    description = "Also known as skopt. A simple and efficient library for optimizing (very) expensive and noisy black-box functions";
    homepage = "https://github.com/holgern/scikit-optimize";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      classic-ally
      hcenge
    ];
  };
}
