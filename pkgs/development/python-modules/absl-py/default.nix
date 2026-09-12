{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
}:
buildPythonPackage (finalAttrs: {
  pname = "absl-py";
  version = "2.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "abseil";
    repo = "abseil-py";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BnR9QnZ5AaSlboQuQnX4UKGjAVVpyzMLZ68Do3VZrE0=";
  };

  build-system = [ hatchling ];

  # checks use bazel; should be revisited
  doCheck = false;

  pythonImportsCheck = [ "absl" ];

  meta = {
    description = "Abseil Python Common Libraries";
    homepage = "https://github.com/abseil/abseil-py";
    changelog = "https://github.com/abseil/abseil-py/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
