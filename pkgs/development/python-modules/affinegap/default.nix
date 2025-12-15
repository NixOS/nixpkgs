{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython,
  setuptools,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "affinegap";
  version = "1.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dedupeio";
    repo = "affinegap";
    tag = "v${version}";
    hash = "sha256-9eX41eoME5Vdtq+c04eQbMYnViy6QKOhKkafrkeMylI=";
  };

  build-system = [
    cython
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # Prevent importing from source during test collection (only $out has compiled extensions)
  preCheck = ''
    rm -rf affinegap
  '';

  pythonImportsCheck = [
    "affinegap"
  ];

  meta = {
    description = "Cython implementation of the affine gap string distance";
    homepage = "https://github.com/dedupeio/affinegap";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ daniel-fahey ];
  };
}
