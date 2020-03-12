{ stdenv, buildPythonPackage, fetchFromGitHub, setuptools
, numpy, scipy, gpy, emcee, nose }:

buildPythonPackage rec {
  pname = "GPyOpt";
  version = "unstable-2019-09-25";

  src = fetchFromGitHub {
    repo   = pname;
    owner  = "SheffieldML";
    rev    = "249b8ff29c52c12ed867f145a627d529372022d8";
    sha256 = "1ywaw1kpdr7dv4s4cr7afmci86sw7w61178gs45b0lq08652zdlb";
  };

  doCheck = false;  # requires several packages not available in Nix

  checkInputs = [ nose ];

  checkPhase = "nosetests -v GPyOpt/testing";

  propagatedBuildInputs = [ setuptools numpy scipy gpy emcee ];

  meta = with stdenv.lib; {
    description = "Bayesian optimization toolbox in Python";
    homepage = https://sheffieldml.github.io/GPyOpt;
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
