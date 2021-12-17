{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, pytestCheckHook
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "emcee";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "dfm";
    repo = pname;
    rev = "v${version}";
    sha256 = "0q9dj7mihjjkcy6famzwhz1xcxxzzvm00n01w4bbm66ax9zvis52";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    numpy
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "emcee" ];

  meta = with lib; {
    description = "Kick ass affine-invariant ensemble MCMC sampling";
    homepage = "https://emcee.readthedocs.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
