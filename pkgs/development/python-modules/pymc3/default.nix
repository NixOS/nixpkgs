{ lib
, fetchurl
, buildPythonPackage
, Theano
, gfortran
, openblas
, numpy
, scipy
, matplotlib
, h5py
, pandas
, patsy
, tqdm
, joblib
}:

buildPythonPackage rec {
  pname = "pymc3";
  version = "3.2";

  propagatedBuildInputs = [
    Theano
    gfortran
    openblas
    numpy
    scipy
    matplotlib
    # unzip
    h5py
    pandas
    patsy
    tqdm
    joblib
  ];

  doCheck = false;

  src = fetchurl {
    url = "https://github.com/pymc-devs/pymc3/archive/v${version}.zip";
    sha256 = "091vwngzv7pfwgb1rba52f6rma4lmz1livbf1qgk4lsgp15vw145";
  };

  meta = {
    description = "Bayesian estimation, particularly using Markov chain Monte Carlo (MCMC)";
    homepage = http://github.com/pymc-devs/pymc3;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ilya-kolpakov ];
  };
}
