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
, filelock
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
, tomli
, tomlkit
, trove-classifiers
, urllib3
, virtualenv
, xattr
}:

buildPythonPackage rec {
  pname = "poetry";
  version = "1.3.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "python-poetry";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-yiV2Y0vBF0d7BFfT5wonzRUGHVH040PZrlAUpVTFCZc=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  propagatedBuildInputs = [
    cachecontrol
    cleo
    crashtest
    dulwich
    filelock
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
    trove-classifiers
    virtualenv
  ] ++ lib.optionals (stdenv.isDarwin) [
    xattr
  ] ++ lib.optionals (pythonOlder "3.11") [
    tomli
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
    cachy
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
    changelog = "https://github.com/python-poetry/poetry/blob/${src.rev}/CHANGELOG.md";
    homepage = "https://python-poetry.org/";
    description = "Python dependency management and packaging made easy";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
