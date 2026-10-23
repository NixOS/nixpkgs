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
  version = "4.2.10";
  format = "wheel";

  src = fetchPypi {
    pname = "AeroSandbox";
    inherit (finalAttrs) version;
    format = "wheel";

    python = "py3";
    dist = "py3";
    hash = "sha256-usUf1Fdz0h0rdoSLj8Nm984KLZ88Eo+RoTBA7ppJkyM=";
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

  pythonRemoveDeps = [
    # infinite recursion
    "neuralfoil"
    # not pypa-installed, so no metadata
    # good candidate for https://github.com/NixOS/nixpkgs/pull/518530
    "casadi"
  ];

  meta = {
    description = "Aircraft design optimization made fast through modern automatic differentiation";
    homepage = "https://peterdsharpe.github.io/AeroSandbox";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
})
