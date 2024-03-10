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
  version = "3.1.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "dfm";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-K2cPSbR7jnl9Vzf2sEiPZqk2vTwgChNWAf6CAerhZCg=";
  };

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
    changelog = "https://github.com/dfm/emcee/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
