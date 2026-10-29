{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyramid,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyramid-multiauth";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mozilla-services";
    repo = "pyramid_multiauth";
    tag = finalAttrs.version;
    hash = "sha256-tDQENdM+eeAve3DoU3bXMP4k1hSIQ6FlFNlG+rVYhOc=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ pyramid ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    changelog = "https://github.com/mozilla-services/pyramid_multiauth/releases/tag/${finalAttrs.version}";
    description = "Authentication policy for Pyramid that proxies to a stack of other authentication policies";
    homepage = "https://github.com/mozilla-services/pyramid_multiauth";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
  };
})
