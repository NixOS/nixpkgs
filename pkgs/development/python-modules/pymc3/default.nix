{ stdenv
, fetchurl
, buildPythonPackage
, Theano
, gfortran
, openblas
, numpy
, scipy
, matplotlib
, h5py
, patsy
}:

buildPythonPackage rec {
  pname = "pymc3";
  version = "v3.2";

  propagatedBuildInputs = [
    Theano
    gfortran
    openblas
    numpy
    scipy
    matplotlib
    # unzip
    h5py
    patsy
  ];

  doCheck = false;

  src = fetchurl {
    url = "https://github.com/pymc-devs/pymc3/archive/${version}.zip";
    sha256 = "091vwngzv7pfwgb1rba52f6rma4lmz1livbf1qgk4lsgp15vw145";
  };

  meta = with stdenv.lib; {
    description = "Bayesian estimation, particularly using Markov chain Monte Carlo (MCMC)";
    homepage = http://github.com/pymc-devs/pymc3;
  };
}
