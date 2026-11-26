{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,

  # nativeBuildInputs
  cmake,
  rustPlatform,
  rustc,
  cargo,
  installShellFiles,
  pkg-config,

  # buildInputs
  corrosion,
  libuuid,
  sqlite,

  # passthru.tests
  nixosTests,

  # nativeCheckInputs
  python3,

  # nativeInstallCheckInputs
  versionCheckHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "taskwarrior";
  version = "3.6.0";
  src = fetchFromGitHub {
    owner = "GothenburgBitFactory";
    repo = "taskwarrior";
    tag = "v${finalAttrs.version}";
    hash = "sha256-X2h87zC0LK+qxqF8jcXix2o5qRTNkL6HnXyc6Gy9JxE=";
    fetchSubmodules = true;
  };
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-wPiXV0V6Yyoqm9oveDFd9qS3tdtxQiPOjRaC+sCPbeI=";
  };

  # The CMakeLists files used by upstream issue a `cargo install` command to
  # install a rust tool (cxxbridge-cmd) that is supposed to be included in the Cargo.toml's and
  # `Cargo.lock` files of upstream. Setting CARGO_HOME like that helps `cargo
  # install` find the dependencies we prefetched. See also:
  # https://github.com/GothenburgBitFactory/taskwarrior/issues/3705
  postUnpack = ''
    export CARGO_HOME=$PWD/.cargo
  '';
  cmakeFlags = [
    (lib.cmakeBool "SYSTEM_CORROSION" true)
  ];
  failingTests = [
    # It would be very hard to make this test succeed, as the bash completion
    # needs to be installed and the builder's `bash` should be aware of it.
    # Doesn't worth the effort. See also:
    # https://github.com/GothenburgBitFactory/taskwarrior/issues/3727
    "bash_completion.test.py"
  ];
  # Contains Bash and Python scripts used while testing.
  preConfigure = ''
    patchShebangs test
  ''
  + lib.optionalString (builtins.length finalAttrs.failingTests > 0) ''
    substituteInPlace test/CMakeLists.txt \
      ${lib.concatMapStringsSep "\\\n  " (t: "--replace-fail ${t} '' ") finalAttrs.failingTests}
  '';

  strictDeps = true;
  nativeBuildInputs = [
    cmake
    rustPlatform.cargoSetupHook
    # To install cxxbridge-cmd before configurePhase, see above linked upstream
    # issue.
    rustc
    cargo
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    corrosion
    libuuid
    sqlite
  ];

  # The test suite is run as an installCheck instead of a check: since
  # https://github.com/GothenburgBitFactory/taskwarrior/commit/76537e107da1654e81df9713df25dbb8fadf4320
  # (3.5.0) the default config includes `default.theme`, which `task` looks
  # up at its compiled-in $out/share/doc/task/rc (TASK_RCDIR). That path is
  # only populated once `installPhase` has run, so the tests need to run
  # after install, not before.
  doInstallCheck = true;
  # See:
  # https://github.com/GothenburgBitFactory/taskwarrior/blob/v3.4.1/doc/devel/contrib/development.md#run-the-test-suite
  preInstallCheck = ''
    make test_runner
  '';
  installCheckTarget = "test";
  nativeInstallCheckInputs = [
    python3
    versionCheckHook
  ];

  versionCheckProgram = "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}";

  postInstall = ''
    # Install vim and neovim plugin
    mkdir -p $out/share/vim-plugins
    mv $out/share/doc/task/scripts/vim $out/share/vim-plugins/task
    mkdir -p $out/share/nvim
    ln -s $out/share/vim-plugins/task $out/share/nvim/site
  '';

  passthru.tests.nixos = nixosTests.taskchampion-sync-server;

  meta = {
    changelog = "https://github.com/GothenburgBitFactory/taskwarrior/releases/tag/${finalAttrs.src.tag}";
    description = "Highly flexible command-line tool to manage TODO lists";
    homepage = "https://taskwarrior.org";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      oxalica
      mlaradji
      doronbehar
      Necior
      me-and
    ];
    mainProgram = "task";
    platforms = lib.platforms.unix;
  };
})
