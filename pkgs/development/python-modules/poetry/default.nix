{ lib, buildPythonPackage, fetchFromGitHub, isPy27, pythonOlder, fetchpatch
, cachecontrol
, cachy
, cleo
, clikit
, html5lib
, httpretty
, importlib-metadata
, intreehooks
, keyring
, lockfile
, pexpect
, pkginfo
, poetry-core
, pytestCheckHook
, pytest-cov
, pytest-mock
, requests
, requests-toolbelt
, shellingham
, tomlkit
, virtualenv
}:

buildPythonPackage rec {
  pname = "poetry";
  version = "1.1.11";
  format = "pyproject";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "python-poetry";
    repo = pname;
    rev = version;
    sha256 = "1f3y3gav2snvcf2h9mbkinvnlcyl9kndf6bh6j0vxkxzlmb4zilx";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
     --replace 'importlib-metadata = {version = "^1.6.0", python = "<3.8"}' \
       'importlib-metadata = {version = ">=1.6", python = "<3.8"}' \
     --replace 'version = "^21.2.0"' 'version = ">=21.2"'
  '';

  nativeBuildInputs = [ intreehooks ];

  propagatedBuildInputs = [
    cachecontrol
    cachy
    cleo
    clikit
    html5lib
    keyring
    lockfile
    pexpect
    pkginfo
    poetry-core
    requests
    requests-toolbelt
    shellingham
    tomlkit
    virtualenv
  ] ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  postInstall = ''
    mkdir -p "$out/share/bash-completion/completions"
    "$out/bin/poetry" completions bash > "$out/share/bash-completion/completions/poetry"
    mkdir -p "$out/share/zsh/vendor-completions"
    "$out/bin/poetry" completions zsh > "$out/share/zsh/vendor-completions/_poetry"
    mkdir -p "$out/share/fish/vendor_completions.d"
    "$out/bin/poetry" completions fish > "$out/share/fish/vendor_completions.d/poetry.fish"
  '';

  checkInputs = [ pytestCheckHook httpretty pytest-mock pytest-cov ];
  preCheck = "export HOME=$TMPDIR";
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
  ];

  patches = [
    # The following patch addresses a minor incompatibility with
    # pytest-mock.  This is addressed upstream in
    # https://github.com/python-poetry/poetry/pull/3457
    (fetchpatch {
      url = "https://github.com/python-poetry/poetry/commit/8ddceb7c52b3b1f35412479707fa790e5d60e691.diff";
      sha256 = "yHjFb9xJBLFOqkOZaJolKviTdtST9PMFwH9n8ud2Y+U=";
    })
  ];

  # allow for package to use pep420's native namespaces
  pythonNamespaces = [ "poetry" ];

  meta = with lib; {
    homepage = "https://python-poetry.org/";
    description = "Python dependency management and packaging made easy";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
