{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  numpy,
  scipy,
  pandas,
  matplotlib,
  seaborn,
  tqdm,
  sortedcontainers,
  dill,
  casadi,
}:

buildPythonPackage rec {
  pname = "aerosandbox";
  version = "4.2.6";
  format = "wheel";

  src = fetchPypi {
    pname = "AeroSandbox";
    inherit version format;

    python = "py3";
    dist = "py3";
    hash = "sha256-jS1Eh/+2WXZkQC4pt1Rwvw7plJC1NFFC08gqzEyGir4=";
  };

  build-system = [ setuptools ];
  dependencies = [
    numpy
    scipy
    pandas
    matplotlib
    seaborn
    tqdm
    sortedcontainers
    dill
    casadi
  ];

  pythonImportsCheck = [ "aerosandbox" ];

  meta = {
    description = "Aircraft design optimization made fast through modern automatic differentiation";
    homepage = "https://peterdsharpe.github.io/AeroSandbox";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
