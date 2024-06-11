{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyramid,
  unittestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyramid-multiauth";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mozilla-services";
    repo = "pyramid_multiauth";
    rev = "refs/tags/${version}";
    hash = "sha256-+Aa+Vc4qCqDe/W5m/RBpYAyOMJkBv+ZGSqElJlkHqs4=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ pyramid ];

  nativeCheckInputs = [ unittestCheckHook ];

  meta = with lib; {
    changelog = "https://github.com/mozilla-services/pyramid_multiauth/releases/tag/${version}";
    description = "Authentication policy for Pyramid that proxies to a stack of other authentication policies";
    homepage = "https://github.com/mozilla-services/pyramid_multiauth";
    license = licenses.mpl20;
    maintainers = with maintainers; [ ];
  };
}
