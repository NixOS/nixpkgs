{
  lib,
  buildPythonPackage,
  isPyPy,
  fetchFromGitHub,
  setuptools,
  attrs,
  exceptiongroup,
  pexpect,
  doCheck ? true,
  pytestCheckHook,
  pytest-xdist,
  python,
  sortedcontainers,
  stdenv,
  pythonAtLeast,
  pythonOlder,
  sphinxHook,
  sphinx-rtd-theme,
  sphinx-hoverxref,
  sphinx-codeautolink,
  tzdata,
}:

buildPythonPackage rec {
  pname = "hypothesis";
  version = "6.131.17";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "HypothesisWorks";
    repo = "hypothesis";
    rev = "hypothesis-python-${version}";
    hash = "sha256-bNaDC2n0VaI7L4/FdD8eQ4cqn5ewquy89wV/pQn9uo0=";
  };

  # I tried to package sphinx-selective-exclude, but it throws
  # error about "module 'sphinx' has no attribute 'directives'".
  #
  # It probably has to do with monkey-patching internals of Sphinx.
  # On bright side, this extension does not introduces new commands,
  # only changes "::only" command, so we probably okay with stock
  # implementation.
  #
  # I wonder how upstream of "hypothesis" builds documentation.
  postPatch = ''
    sed -i -e '/sphinx_selective_exclude.eager_only/ d' docs/conf.py
  '';

  postUnpack = "sourceRoot=$sourceRoot/hypothesis-python";

  build-system = [ setuptools ];

  dependencies = [
    attrs
    sortedcontainers
  ] ++ lib.optionals (pythonOlder "3.11") [ exceptiongroup ];

  nativeCheckInputs = [
    pexpect
    pytest-xdist
    pytestCheckHook
  ] ++ lib.optionals isPyPy [ tzdata ];

  inherit doCheck;

  # tox.ini changes how pytest runs and breaks it.
  # Activate the CI profile (similar to setupHook below)
  # by setting HYPOTHESIS_PROFILE [1].
  #
  # [1]: https://github.com/HypothesisWorks/hypothesis/blob/hypothesis-python-6.130.9/hypothesis-python/tests/common/setup.py#L78
  preCheck = ''
    rm tox.ini
    export HYPOTHESIS_PROFILE=ci
  '';

  pytestFlagsArray = [ "tests/cover" ];

  # Hypothesis by default activates several "Health Checks", including one that fires if the builder is "too slow".
  # This check is disabled [1] if Hypothesis detects a CI environment, i.e. either `CI` or `TF_BUILD` is defined [2].
  # We set `CI=1` here using a setup hook to avoid spurious failures [3].
  #
  # Example error message for reference:
  # hypothesis.errors.FailedHealthCheck: Data generation is extremely slow: Only produced 2 valid examples in 1.28 seconds (1 invalid ones and 0 exceeded maximum size). Try decreasing size of the data you're generating (with e.g. max_size or max_leaves parameters).
  #
  # [1]: https://github.com/HypothesisWorks/hypothesis/blob/hypothesis-python-6.130.9/hypothesis-python/src/hypothesis/_settings.py#L816-L828
  # [2]: https://github.com/HypothesisWorks/hypothesis/blob/hypothesis-python-6.130.9/hypothesis-python/src/hypothesis/_settings.py#L756
  # [3]: https://github.com/NixOS/nixpkgs/issues/393637
  setupHook = ./setup-hook.sh;

  disabledTests =
    [
      # racy, fails to find a file sometimes
      "test_recreate_charmap"
      "test_uses_cached_charmap"
      # fail when using CI profile
      "test_given_does_not_pollute_state"
      "test_find_does_not_pollute_state"
      "test_does_print_on_reuse_from_database"
      "test_prints_seed_only_on_healthcheck"
      # calls script with the naked interpreter
      "test_constants_from_running_file"
    ]
    ++ lib.optionals (pythonOlder "3.10") [
      # not sure why these tests fail with only 3.9
      # FileNotFoundError: [Errno 2] No such file or directory: 'git'
      "test_observability"
      "test_assume_has_status_reason"
      "test_observability_captures_stateful_reprs"
    ]
    ++ lib.optionals (pythonAtLeast "3.12") [
      # AssertionError: assert [b'def      \...   f(): pass'] == [b'def\\', b'    f(): pass']
      # https://github.com/HypothesisWorks/hypothesis/issues/4355
      "test_clean_source"
    ];

  pythonImportsCheck = [ "hypothesis" ];

  passthru = {
    doc = stdenv.mkDerivation {
      # Forge look and feel of multi-output derivation as best as we can.
      #
      # Using 'outputs = [ "doc" ];' breaks a lot of assumptions.
      name = "${pname}-${version}-doc";
      inherit src pname version;

      postInstallSphinx = ''
        mv $out/share/doc/* $out/share/doc/python$pythonVersion-$pname-$version
      '';

      nativeBuildInputs = [
        sphinxHook
        sphinx-rtd-theme
        sphinx-hoverxref
        sphinx-codeautolink
      ];

      inherit (python) pythonVersion;
      inherit meta;
    };
  };

  meta = {
    description = "Library for property based testing";
    mainProgram = "hypothesis";
    homepage = "https://github.com/HypothesisWorks/hypothesis";
    changelog = "https://hypothesis.readthedocs.io/en/latest/changes.html#v${
      lib.replaceStrings [ "." ] [ "-" ] version
    }";
    license = lib.licenses.mpl20;
    maintainers = [
      lib.maintainers.fliegendewurst
    ];
  };
}
