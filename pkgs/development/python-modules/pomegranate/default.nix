{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  apricot-select,
  numpy,
  joblib,
  networkx,
  scipy,
  scikit-learn,
  pyyaml,
  cython,
  torch,
}:

buildPythonPackage rec {
  pname = "pomegranate";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    repo = pname;
    owner = "jmschrei";
    # no tags for recent versions: https://github.com/jmschrei/pomegranate/issues/974
    tag = "v${version}";
    hash = "sha256-p2Gn0FXnsAHvRUeAqx4M1KH0+XvDl3fmUZZ7MiMvPSs=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    apricot-select
    numpy
    joblib
    networkx
    scipy
    scikit-learn
    pyyaml
    cython
    torch
  ];

  # https://github.com/etal/cnvkit/issues/815
  passthru.skipBulkUpdate = true;

  meta = with lib; {
    description = "Probabilistic and graphical models for Python, implemented in cython for speed";
    homepage = "https://github.com/jmschrei/pomegranate";
    license = licenses.mit;
    maintainers = with maintainers; [ rybern ];
  };
}
