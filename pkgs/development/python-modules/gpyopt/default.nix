{ lib, buildPythonPackage, fetchFromGitHub, setuptools
, numpy, scipy, gpy, emcee, nose, cython }:

buildPythonPackage rec {
  pname = "GPyOpt";
  version = "1.2.6";

  src = fetchFromGitHub {
    repo   = pname;
    owner  = "SheffieldML";
    rev    = "v${version}";
    sha256 = "1sv13svaks67i9z560746hz4hslakdna0zd3gxj828il1cv7cslm";
  };

  nativeBuildInputs = [ cython ];

  doCheck = false;  # requires several packages not available in Nix

  nativeCheckInputs = [ nose ];

  checkPhase = "nosetests -v GPyOpt/testing";

  propagatedBuildInputs = [ setuptools numpy scipy gpy emcee ];

  pythonImportsCheck = [ "GPyOpt" ];

  meta = with lib; {
    description = "Bayesian optimization toolbox in Python";
    homepage = "https://sheffieldml.github.io/GPyOpt";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
