{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
, wheel
, arviz
, matplotlib
, numpy
, pandas
, pymc
, scikit-learn
, seaborn
, xarray
, xarray-einstats
}:

buildPythonPackage rec {
  pname = "pymc-marketing";
  version = "0.4.2";
  pyproject = true;
  disabled = pythonOlder "3.9";
  src = fetchFromGitHub {
    owner = "pymc-labs";
    repo = "pymc-marketing";
    rev = "refs/tags/${version}";
    hash = "sha256-azG8CughCJPfURlpkcH+YwLdtQ9Lmq3Al2xXOjH1iS8=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    arviz
    matplotlib
    numpy
    pandas
    pymc
    scikit-learn
    seaborn
    xarray
    xarray-einstats
  ];

  pythonImportsCheck = [ "pymc_marketing" ];

  meta = with lib; {
    description = "Bayesian marketing toolbox in PyMC. Media Mix (MMM), customer lifetime value (CLV), buy-till-you-die (BTYD) models and more";
    homepage = "https://github.com/pymc-labs/pymc-marketing";
    license = licenses.asl20;
    maintainers = with maintainers; [ ferrine ];
  };
}
