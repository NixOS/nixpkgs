{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  toolz,
  multipledispatch,
  py,
  pytestCheckHook,
  pytest-html,
  pytest-benchmark,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "logical-unification";
  version = "0.4.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pythological";
    repo = "unification";
    tag = "v${finalAttrs.version}";
    hash = "sha256-m1wB7WOGb/io4Z7Zfl/rckh08j6IKSiiwFKMvl5UzHg=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/pythological/unification/pull/49.patch";
      hash = "sha256-0y1DHxxjQ19upOlstf/zihP1b6iQ4A/WqyWNpirW/kg=";
    })
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    toolz
    multipledispatch
  ];

  nativeCheckInputs = [
    py
    pytestCheckHook
    pytest-html
    pytest-benchmark # Needed for the `--benchmark-skip` flag
  ];

  pytestFlags = [
    "--benchmark-skip"
    "--html=testing-report.html"
    "--self-contained-html"
  ];

  pythonImportsCheck = [ "unification" ];

  meta = {
    description = "Straightforward unification in Python that's extensible via generic functions";
    homepage = "https://github.com/pythological/unification";
    changelog = "https://github.com/pythological/unification/releases";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ Etjean ];
  };
})
