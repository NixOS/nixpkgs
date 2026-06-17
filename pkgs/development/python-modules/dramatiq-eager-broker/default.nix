{
  lib,
  buildPythonPackage,
  fetchFromGitea,
  uv-build,
  dramatiq,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "dramatiq-eager-broker";
  version = "0.3.0";

  pyproject = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "yaal";
    repo = "dramatiq-eager-broker";
    tag = version;
    hash = "sha256-tz4Gy31y5oaTHFAzb5L7bg0AhG1U/JKDySGloA7/A/8=";
  };

  build-system = [ uv-build ];

  dependencies = [ dramatiq ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "An eager broker for Dramatiq that executes tasks synchronously and immediately, without queuing";
    homepage = "https://codeberg.org/yaal/dramatiq-eager-broker";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.erictapen ];
  };
}
