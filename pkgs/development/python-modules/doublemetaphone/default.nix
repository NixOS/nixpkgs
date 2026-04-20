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
  pname = "doublemetaphone";
  version = "1.2i";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dedupeio";
    repo = "doublemetaphone";
    tag = "v${version}";
    hash = "sha256-VPJqHxQHLiLSko+aJYTIgISluHPARgQN5pYWYxP9QKQ=";
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
    rm -rf doublemetaphone
  '';

  pythonImportsCheck = [
    "doublemetaphone"
  ];

  meta = {
    description = "Python wrapper for Double Metaphone phonetic encoding algorithm";
    homepage = "https://github.com/dedupeio/doublemetaphone";
    license = lib.licenses.artistic1;
    maintainers = with lib.maintainers; [ daniel-fahey ];
  };
}
