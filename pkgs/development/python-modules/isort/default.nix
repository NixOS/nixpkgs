{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  colorama,
  hatchling,
  hatch-vcs,
  hypothesis,
  mypy-extensions,
  pylama,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "isort";
  version = "9.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = "isort";
    tag = version;
    hash = "sha256-y0Uh2OU3aVrHwyXsdAWpZBYW1qhItzTMTVA46wvNawU=";
  };

  # Drop hatch-mypyc from build-system; hatchling still resolves its mypy/ast-serialize chain.
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'requires = ["hatchling", "hatch-vcs", "hatch-mypyc"]' \
                     'requires = ["hatchling", "hatch-vcs"]'
  '';

  build-system = [
    hatchling
    hatch-vcs
  ];

  # isort imports mypy_extensions at runtime unconditionally.
  dependencies = [
    mypy-extensions
  ];

  nativeCheckInputs = [
    colorama
    hypothesis
    pylama
    pytestCheckHook
  ];

  postCheck = ''
    # Verify the wrapped executable runs without PYTHONPATH.
    (
      unset PYTHONPATH
      echo "Testing that `isort --version` returns OK..."
      $out/bin/isort --version
    )
  '';

  preCheck = ''
    HOME=$TMPDIR
    export PATH=$PATH:$out/bin
  '';

  disabledTestPaths = [
    "tests/benchmark/" # requires pytest-benchmark
    "tests/integration/" # pulls in 10 other packages
    "tests/unit/profiles/test_black.py" # causes infinite recursion to include black
  ];

  disabledTests = [
    "test_run" # doesn't like paths in /build
    "test_fuzz_show_unified_diff" # flakey
    "test_pyi_formatting_issue_942"
    "test_requirements_finder"
    "test_pipfile_finder"
    "test_main" # relies on git
    "test_command_line" # not thread safe
    "test_encoding_not_in_comment" # not python 3.9 compatible
    "test_encoding_not_in_first_two_lines" # not python 3.9 compatible
    "test_requirements_dir" # requires network
    # requires `black` (a dev dependency, not needed for isort)
    "test_sort_reexports_output_is_black_stable_issue_2280"
    # needs example-isort-sorting-plugin (unpackaged) for the `natural_plus` sort
    "test_sort_configurable_sort_issue_1732"
    # needs example-shared-isort-profile (unpackaged) for the `example` profile
    "test_isort_supports_shared_profiles_issue_970"
    # https://github.com/PyCQA/isort/issues/2234
    "test_isort_should_warn_on_empty_custom_config_issue_1433"
  ];

  meta = {
    description = "Python utility / library to sort Python imports";
    homepage = "https://github.com/PyCQA/isort";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      couchemar
      lonerOrz
    ];
    mainProgram = "isort";
  };
}
