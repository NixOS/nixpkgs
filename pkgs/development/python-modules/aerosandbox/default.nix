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

buildPythonPackage (finalAttrs: {
  pname = "aerosandbox";
  version = "4.2.9";
  format = "wheel";

  src = fetchPypi {
    pname = "AeroSandbox";
    inherit (finalAttrs) version;
    format = "wheel";

    python = "py3";
    dist = "py3";
    hash = "sha256-8ANpuRayPIMXiNnVNNO4fThpSVgA4jE6goc0qy7Kj+E=";
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
})
