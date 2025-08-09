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
  pythonOlder,
  installShellFiles,
  rustPlatform,
  rustc,
  setuptools-gettext,
  setuptools-rust,
  testers,
}:

buildPythonPackage rec {
  pname = "breezy";
  version = "3.3.12";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "breezy-team";
    repo = "breezy";
    rev = "brz-${version}";
    hash = "sha256-V/SnzpslFGjISg+YxViFa+Lpnn0+9enPA3xmvwfXnUM=";
  };

  cargoDeps = rustPlatform.importCargoLock { lockFile = ./Cargo.lock; };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = [
    cython
    installShellFiles
    rustPlatform.cargoSetupHook
    cargo
    rustc
    setuptools-gettext
    setuptools-rust
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  propagatedBuildInputs = [
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

  meta = with lib; {
    description = "Friendly distributed version control system";
    homepage = "https://www.breezy-vcs.org/";
    changelog = "https://github.com/breezy-team/breezy/blob/${src.rev}/doc/en/release-notes/brz-${versions.majorMinor version}.txt";
    license = licenses.gpl2Only;
    maintainers = [ ];
    mainProgram = "brz";
  };
}
