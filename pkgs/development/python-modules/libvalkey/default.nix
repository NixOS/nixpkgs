{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "libvalkey-py";
  version = "4.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "valkey-io";
    repo = "libvalkey-py";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-tOq4SC9xA1rXfclqIzseedu7lyQ+7ZcVy/4ELTAorJ4=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "libvalkey" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    # import from $out
    rm -r libvalkey
  '';

  meta = {
    changelog = "https://github.com/valkey-io/libvalkey-py/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Python wrapper for libvalkey";
    homepage = "https://github.com/valkey-io/libvalkey-py";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
