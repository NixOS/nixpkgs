{ lib
, aeppl
, aesara
, arviz
, buildPythonPackage
, cachetools
, cloudpickle
, fastprogress
, fetchFromGitHub
, numpy
, pythonOlder
, scipy
, typing-extensions
}:

buildPythonPackage rec {
  pname = "pymc3";
  version = "unstable-2022-05-23";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pymc-devs";
    repo = "pymc3";
    rev = "b5a5b569779673914c9420c1cc0135b118505ff5";
    hash = "sha256-vkIFwdjX2Rex8oqscVMP4xh0K4bjmN/RL7aQmOI//Dw=";
  };

  propagatedBuildInputs = [
    aeppl
    aesara
    arviz
    cachetools
    cloudpickle
    fastprogress
    numpy
    scipy
    typing-extensions
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace ', "pytest-cov"' ""
    substituteInPlace requirements.txt \
      --replace "aesara==2.6.2" "aesara" \
      --replace "aeppl==0.0.28" "aeppl"
  '';

  # The test suite is computationally intensive and test failures are not
  # indicative for package usability hence tests are disabled by default.
  doCheck = false;

  pythonImportsCheck = [
    "pymc"
  ];

  meta = with lib; {
    description = "Bayesian estimation, particularly using Markov chain Monte Carlo (MCMC)";
    homepage = "https://github.com/pymc-devs/pymc3";
    license = licenses.asl20;
    maintainers = with maintainers; [ nidabdella ];
  };
}
