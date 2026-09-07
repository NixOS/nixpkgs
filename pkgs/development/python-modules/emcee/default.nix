{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  pytestCheckHook,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "emcee";
  version = "3.1.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "dfm";
    repo = "emcee";
    tag = "v${version}";
    hash = "sha256-JVZK3kvDwWENho0OxZ9OxATcm3XpGmX+e7alPclRsHY=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ numpy ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "emcee" ];

  meta = {
    description = "Kick ass affine-invariant ensemble MCMC sampling";
    homepage = "https://emcee.readthedocs.io/";
    changelog = "https://github.com/dfm/emcee/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
