{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  aiosmtpd,
  jaraco-text,
  jaraco-collections,
  keyring,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "jaraco-email";
  version = "3.1.1";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "jaraco";
    repo = "jaraco.email";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2dU+tbrP86Oy8ej1Xa0+fNRB83tGBTUsOWbZyQsMKu8=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    aiosmtpd
    jaraco-text
    jaraco-collections
    keyring
  ];

  pythonImportsCheck = [ "jaraco.email" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    changelog = "https://github.com/jaraco/jaraco.email/blob/${finalAttrs.src.tag}/NEWS.rst";
    description = "E-mail facilities by jaraco";
    homepage = "https://github.com/jaraco/jaraco.email";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
