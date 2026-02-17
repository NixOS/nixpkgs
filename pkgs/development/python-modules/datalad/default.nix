{
  buildPythonPackage,
  lib,
  setuptools,
  stdenv,
  fetchFromGitHub,
  pythonAtLeast,
  installShellFiles,
  git,
  versioneer,
  # core
  platformdirs,
  chardet,
  iso8601,
  humanize,
  fasteners,
  packaging,
  patool,
  tqdm,
  annexremote,
  looseversion,
  git-annex,
  # downloaders
  boto3,
  keyrings-alt,
  keyring,
  msgpack,
  requests,
  # publish
  python-gitlab,
  # misc
  argcomplete,
  pyperclip,
  python-dateutil,
  # duecredit
  duecredit,
  distro,
  # win
  colorama,
  # tests
  pytest-retry,
  pytest-xdist,
  pytestCheckHook,
  p7zip,
  curl,
  httpretty,
}:

buildPythonPackage (finalAttrs: {
  pname = "datalad";
  version = "1.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "datalad";
    repo = "datalad";
    tag = finalAttrs.version;
    hash = "sha256-cVsbEHM1zJYxzxHuoxErxGe4w5ioYZn11t5BvtXnH4A=";
  };

  postPatch = ''
    # Remove vendorized versioneer.py
    rm versioneer.py
  '';

  nativeBuildInputs = [
    installShellFiles
    git
  ];

  build-system = [
    setuptools
    versioneer
  ];

  dependencies =
    finalAttrs.passthru.optional-dependencies.core
    ++ finalAttrs.passthru.optional-dependencies.downloaders
    ++ finalAttrs.passthru.optional-dependencies.publish;

  optional-dependencies = {
    core = [
      platformdirs
      chardet
      distro
      iso8601
      humanize
      fasteners
      packaging
      patool
      tqdm
      annexremote
      looseversion
    ]
    ++ lib.optionals stdenv.hostPlatform.isWindows [ colorama ];
    downloaders = [
      boto3
      keyrings-alt
      keyring
      msgpack
      requests
    ];
    downloaders-extra = [
      # requests-ftp # not in nixpkgs yet
    ];
    publish = [ python-gitlab ];
    misc = [
      argcomplete
      pyperclip
      python-dateutil
    ];
    duecredit = [ duecredit ];
  };

  postInstall = ''
    installShellCompletion --cmd datalad \
      --bash <($out/bin/datalad shell-completion) \
      --zsh  <($out/bin/datalad shell-completion)
    wrapProgram $out/bin/datalad \
      --prefix PATH : "${git-annex}/bin" \
      --prefix PYTHONPATH : "$PYTHONPATH"
  '';

  preCheck = ''
    export HOME=$TMPDIR
    export DATALAD_TESTS_NONETWORK=1
    export PATH="$PATH:$out/bin"
  '';

  disabledTestMarks = [
    "flaky"
  ];

  disabledTests = [
    # Tries to run `git` and fails
    "test_reckless"
    "test_create"
    "test_subsuperdataset_save"

    # Tries to spawn a subshell and fails
    "test_shell_completion_source"

    # Times out
    "test_rerun_unrelated_nonrun_left_run_right"

    # Top five slowest (2/3 of total runtime)
    "test_files_split"
    "test_gitannex_local"
    "test_save_hierarchy"
    "test_recurse_existing"
    "test_source_candidate_subdataset"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # pbcopy not found
    "test_wtf"
    # hangs
    "test_keyring"
  ];

  nativeCheckInputs = [
    p7zip
    pytest-retry
    pytest-xdist
    pytestCheckHook
    git-annex
    curl
    httpretty
  ];

  pytestFlags = [
    # Deprecated in 3.13. Use exc_type_str instead.
    "-Wignore::DeprecationWarning"
  ];

  # Tests use ports on localhost
  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "datalad" ];

  meta = {
    description = "Keep code, data, containers under control with git and git-annex";
    homepage = "https://www.datalad.org";
    changelog = "https://github.com/datalad/datalad/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      renesat
      malik
      sarahec
    ];
  };
})
