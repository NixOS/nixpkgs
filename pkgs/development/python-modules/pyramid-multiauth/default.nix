{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyramid,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pyramid-multiauth";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mozilla-services";
    repo = "pyramid_multiauth";
    tag = version;
    hash = "sha256-Bz53iCGsl6WZASIvBQ1pFfcGLra82vA2OLWjhLVdkrw=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ pyramid ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    changelog = "https://github.com/mozilla-services/pyramid_multiauth/releases/tag/${version}";
    description = "Authentication policy for Pyramid that proxies to a stack of other authentication policies";
    homepage = "https://github.com/mozilla-services/pyramid_multiauth";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
  };
}
