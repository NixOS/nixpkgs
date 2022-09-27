{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, pytestCheckHook
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "emcee";
  version = "3.1.3";

  src = fetchFromGitHub {
    owner = "dfm";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-HAuwWFNL63BlvHomQx+hWw4et7kRYd3zhH2FAj632Lg=";
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
