{ lib
, backports-cached-property
, buildPythonPackage
, cachecontrol
, cachy
, cleo
, crashtest
, deepdiff
, dulwich
, fetchFromGitHub
, flatdict
, html5lib
, httpretty
, importlib-metadata
, installShellFiles
, intreehooks
, jsonschema
, keyring
, lockfile
, packaging
, pexpect
, pkginfo
, platformdirs
, poetry-core
, poetry-plugin-export
, pytest-mock
, pytest-xdist
, pytestCheckHook
, pythonAtLeast
, pythonOlder
, requests
, requests-toolbelt
, shellingham
, stdenv
, tomlkit
, urllib3
, virtualenv
, xattr
}:

buildPythonPackage rec {
  pname = "poetry";
  version = "1.2.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "python-poetry";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-huIjLv1T42HEmePCQNJpKnNxJKdyD9MlEtc2WRPOjRE=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'crashtest = "^0.3.0"' 'crashtest = "*"' \
      --replace 'xattr = { version = "^0.9.7"' 'xattr = { version = "^0.10.0"'
  '';

  nativeBuildInputs = [
    installShellFiles
  ];

  propagatedBuildInputs = [
    cachecontrol
    cachy
    cleo
    crashtest
    dulwich
    html5lib
    jsonschema
    keyring
    packaging
    pexpect
    pkginfo
    platformdirs
    poetry-core
    poetry-plugin-export
    requests
    requests-toolbelt
    shellingham
    tomlkit
    virtualenv
  ] ++ lib.optionals (stdenv.isDarwin) [
    xattr
  ] ++ lib.optionals (pythonOlder "3.10") [
    importlib-metadata
  ] ++ lib.optionals (pythonOlder "3.8") [
    backports-cached-property
  ] ++ cachecontrol.optional-dependencies.filecache;

  postInstall = ''
    installShellCompletion --cmd poetry \
      --bash <($out/bin/poetry completions bash) \
      --fish <($out/bin/poetry completions fish) \
      --zsh <($out/bin/poetry completions zsh) \
  '';

  checkInputs = [
    deepdiff
    flatdict
    pytestCheckHook
    httpretty
    pytest-mock
    pytest-xdist
  ];

  preCheck = (''
    export HOME=$TMPDIR
  '' + lib.optionalString (stdenv.isDarwin && stdenv.isAarch64) ''
    # https://github.com/python/cpython/issues/74570#issuecomment-1093748531
    export no_proxy='*';
  '');

  postCheck = lib.optionalString (stdenv.isDarwin && stdenv.isAarch64) ''
    unset no_proxy
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
