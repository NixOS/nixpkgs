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
  version = "2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dedupeio";
    repo = "affinegap";
    tag = "pypideploy${version}";
    hash = "sha256-TuydLF3YfeVIP2y2uDQH+oZ9Y2b325ZFEM0Fiu0Xhus=";
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
