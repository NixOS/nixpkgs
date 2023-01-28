{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, pytestCheckHook
, setuptools-scm
, pythonOlder
}:

buildPythonPackage rec {
  pname = "emcee";
  version = "3.1.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "dfm";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-HAuwWFNL63BlvHomQx+hWw4et7kRYd3zhH2FAj632Lg=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    numpy
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "emcee"
  ];

  meta = with lib; {
    description = "Kick ass affine-invariant ensemble MCMC sampling";
    homepage = "https://emcee.readthedocs.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
