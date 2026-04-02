{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  cargo,
  configobj,
  cython,
  dulwich,
  fastbencode,
  fastimport,
  pygithub,
  libiconv,
  merge3,
  patiencediff,
  pyyaml,
  tzlocal,
  urllib3,
  breezy,
  launchpadlib,
  testtools,
  installShellFiles,
  rustPlatform,
  rustc,
  setuptools-gettext,
  setuptools-rust,
  testers,
}:

buildPythonPackage rec {
  pname = "breezy";
  version = "3.3.21";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "breezy-team";
    repo = "breezy";
    tag = "brz-${version}";
    hash = "sha256-S8YHFEWiSnkBFO75jMuEcvVZSnoV9SGCH/Ueodq2zow=";
  };

  cargoDeps = rustPlatform.importCargoLock { lockFile = ./Cargo.lock; };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = [
    installShellFiles
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  build-system = [
    cython
    setuptools-gettext
    setuptools-rust
  ];

  dependencies = [
    configobj
    dulwich
    fastbencode
    merge3
    patiencediff
    pyyaml
    tzlocal
    urllib3
  ]
  ++ optional-dependencies.launchpad
  ++ optional-dependencies.fastimport
  ++ optional-dependencies.github;

  optional-dependencies = {
    launchpad = [ launchpadlib ];
    fastimport = [ fastimport ];
    github = [ pygithub ];
  };

  nativeCheckInputs = [ testtools ];

  # multiple failures on sandbox
  doCheck = false;

  checkPhase = ''
    runHook preCheck

    HOME=$TMPDIR $out/bin/brz --no-plugins selftest

    runHook postCheck
  '';

  postInstall = ''
    wrapProgram $out/bin/brz --prefix PYTHONPATH : "$PYTHONPATH"

    # symlink for bazaar compatibility
    ln -s "$out/bin/brz" "$out/bin/bzr"

    installShellCompletion --cmd brz --bash contrib/bash/brz
  '';

  pythonImportsCheck = [
    "breezy"
    "breezy.bzr.rio"
  ];

  passthru = {
    tests.version = testers.testVersion {
      package = breezy;
      command = "HOME=$TMPDIR brz --version";
    };
  };

  meta = {
    description = "Friendly distributed version control system";
    homepage = "https://www.breezy-vcs.org/";
    changelog = "https://github.com/breezy-team/breezy/blob/${src.tag}/doc/en/release-notes/brz-${lib.versions.majorMinor version}.txt";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    mainProgram = "brz";
  };
}
