{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  cython,
  setuptools,
  setuptools-git-versioning,
  toolz,
}:

buildPythonPackage (finalAttrs: {
  pname = "cytoolz";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytoolz";
    repo = "cytoolz";
    tag = finalAttrs.version;
    hash = "sha256-beOEhm7+Nq7oA7iDcdORz03D1InHmypqsYUDUXEUPC0=";
  };

  postPatch = ''
    sed -i "/setuptools-git-versioning >=/d" pyproject.toml
    substituteInPlace pyproject.toml \
      --replace-fail "dynamic = [\"version\"]" "version = \"${finalAttrs.version}\""
  '';

  nativeBuildInputs = [
    cython
    setuptools
    setuptools-git-versioning
  ];

  dependencies = [ toolz ];

  # tests are located in cytoolz/tests, but we need to prevent import from the cytoolz source
  preCheck = ''
    mv cytoolz/tests tests
    rm -rf cytoolz
    sed -i "/testpaths/d" pyproject.toml
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    homepage = "https://github.com/pytoolz/cytoolz/";
    changelog = "https://github.com/pytoolz/cytoolz/releases/tag/${finalAttrs.src.tag}";
    description = "Cython implementation of Toolz: High performance functional utilities";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sarahec ];
  };
})
