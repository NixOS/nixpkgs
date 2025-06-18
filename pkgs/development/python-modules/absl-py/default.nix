{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "absl-py";
  version = "2.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "abseil";
    repo = "abseil-py";
    tag = "v${version}";
    hash = "sha256-KsaFfdq6+Pc8k0gM1y+HJ1v6VrTAK7TBgh92BSFuc+Q=";
  };

  build-system = [ setuptools ];

  # checks use bazel; should be revisited
  doCheck = false;

  pythonImportsCheck = [ "absl" ];

  meta = {
    description = "Abseil Python Common Libraries";
    homepage = "https://github.com/abseil/abseil-py";
    changelog = "https://github.com/abseil/abseil-py/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
