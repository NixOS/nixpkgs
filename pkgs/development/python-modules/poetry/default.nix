{ lib
, buildPythonPackage
, cachecontrol
, cachy
, cleo
, clikit
, crashtest
, dataclasses
, entrypoints
, fetchFromGitHub
, fetchpatch
, html5lib
, httpretty
, importlib-metadata
, intreehooks
, keyring
, lockfile
, packaging
, pexpect
, pkginfo
, poetry-core
, pytest-mock
, pytestCheckHook
, pythonAtLeast
, pythonOlder
, requests
, requests-toolbelt
, shellingham
, tomlkit
, virtualenv
}:

buildPythonPackage rec {
  pname = "poetry";
  version = "1.1.12";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "python-poetry";
    repo = pname;
    rev = version;
    sha256 = "1fm4yj6wxr24v7b77gmf63j7xsgszhbhzw2i9fvlfi0p9l0q34pm";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'importlib-metadata = {version = "^1.6.0", python = "<3.8"}' \
       'importlib-metadata = {version = ">=1.6", python = "<3.8"}' \
      --replace 'version = "^21.2.0"' 'version = ">=21.2"' \
      --replace 'packaging = "^20.4"' 'packaging = "*"'
  '';

  nativeBuildInputs = [
    intreehooks
  ];

  propagatedBuildInputs = [
    cachecontrol
    cachy
    cleo
    clikit
    crashtest
    entrypoints
    html5lib
    keyring
    lockfile
    packaging
    pexpect
    pkginfo
    poetry-core
    requests
    requests-toolbelt
    shellingham
    tomlkit
    virtualenv
  ] ++ lib.optionals (pythonOlder "3.7") [
    dataclasses
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  postInstall = ''
    mkdir -p "$out/share/bash-completion/completions"
    "$out/bin/poetry" completions bash > "$out/share/bash-completion/completions/poetry"
    mkdir -p "$out/share/zsh/vendor-completions"
    "$out/bin/poetry" completions zsh > "$out/share/zsh/vendor-completions/_poetry"
    mkdir -p "$out/share/fish/vendor_completions.d"
    "$out/bin/poetry" completions fish > "$out/share/fish/vendor_completions.d/poetry.fish"
  '';

  checkInputs = [
    pytestCheckHook
    httpretty
    pytest-mock
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  disabledTests = [
    # touches network
    "git"
    "solver"
    "load"
    "vcs"
    "prereleases_if_they_are_compatible"
    "test_executor"
    # requires git history to work correctly
    "default_with_excluded_data"
    # toml ordering has changed
    "lock"
    # fs permission errors
    "test_builder_should_execute_build_scripts"
  ] ++ lib.optionals (pythonAtLeast "3.10") [
    # RuntimeError: 'auto_spec' might be a typo; use unsafe=True if this is intended
    "test_info_setup_complex_pep517_error"
  ];

  patches = [
    # The following patch addresses a minor incompatibility with
    # pytest-mock. This is addressed upstream in
    # https://github.com/python-poetry/poetry/pull/3457
    (fetchpatch {
      url = "https://github.com/python-poetry/poetry/commit/8ddceb7c52b3b1f35412479707fa790e5d60e691.diff";
      sha256 = "yHjFb9xJBLFOqkOZaJolKviTdtST9PMFwH9n8ud2Y+U=";
    })
  ];

  # Allow for package to use pep420's native namespaces
  pythonNamespaces = [
    "poetry"
  ];

  meta = with lib; {
    homepage = "https://python-poetry.org/";
    description = "Python dependency management and packaging made easy";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
