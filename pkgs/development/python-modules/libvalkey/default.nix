{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "libvalkey";
  version = "4.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "valkey-io";
    repo = "libvalkey-py";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-L8qbJxMbYL/0fujzm5aRQAD/gm8UO8USgiwsLeMs6Ag=";
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
    changelog = "https://github.com/valkey-io/libvalkey-py/releases/tag/${finalAttrs.src.tag}";
    description = "Python wrapper for libvalkey";
    homepage = "https://github.com/valkey-io/libvalkey-py";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
