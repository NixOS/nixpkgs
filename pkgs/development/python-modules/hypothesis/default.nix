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
  pythonOlder,
  sphinxHook,
  sphinx-rtd-theme,
  sphinx-hoverxref,
  sphinx-codeautolink,
  tzdata,
}:

buildPythonPackage rec {
  pname = "hypothesis";
  version = "6.112.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "HypothesisWorks";
    repo = "hypothesis";
    rev = "hypothesis-python-${version}";
    hash = "sha256-KVi4BAgrswvhZxArYVnYQ6ksvCf84aSEZbJcRSlwsZE=";
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

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    attrs
    sortedcontainers
  ] ++ lib.optionals (pythonOlder "3.11") [ exceptiongroup ];

  nativeCheckInputs = [
    pexpect
    pytest-xdist
    pytestCheckHook
  ] ++ lib.optionals isPyPy [ tzdata ];

  inherit doCheck;

  # This file changes how pytest runs and breaks it
  preCheck = ''
    rm tox.ini
  '';

  pytestFlagsArray = [ "tests/cover" ];

  disabledTests =
    [
      # racy, fails to find a file sometimes
      "test_recreate_charmap"
      "test_uses_cached_charmap"
    ]
    ++ lib.optionals (pythonOlder "3.10") [
      # not sure why these tests fail with only 3.9
      # FileNotFoundError: [Errno 2] No such file or directory: 'git'
      "test_observability"
      "test_assume_has_status_reason"
      "test_observability_captures_stateful_reprs"
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

  meta = with lib; {
    description = "Library for property based testing";
    mainProgram = "hypothesis";
    homepage = "https://github.com/HypothesisWorks/hypothesis";
    changelog = "https://hypothesis.readthedocs.io/en/latest/changes.html#v${
      lib.replaceStrings [ "." ] [ "-" ] version
    }";
    license = licenses.mpl20;
    maintainers = [ ];
  };
}
