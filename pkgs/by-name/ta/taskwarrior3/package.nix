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

  # buildInputs
  corrosion,
  libuuid,

  # passthru.tests
  nixosTests,

  # nativeCheckInputs
  python3,

  # nativeInstallCheckInputs
  versionCheckHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "taskwarrior";
  version = "3.5.0";
  src = fetchFromGitHub {
    owner = "GothenburgBitFactory";
    repo = "taskwarrior";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ckVYO7Z5nF2xvPU4K/dktx/ht4gKTASlzZNkDjXXKyg=";
    fetchSubmodules = true;
  };
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-vNi/gVzIzTXuuPkWNimDwPJG7COWJATzGaT6J4UrrTk=";
  };
  patches = [
    # Installs properly Bash scripts, just like fish. See:
    # https://github.com/GothenburgBitFactory/taskwarrior/pull/4173
    (fetchpatch {
      url = "https://github.com/GothenburgBitFactory/taskwarrior/commit/c1958786deb9be8b245b4fc4c3efd0258cd70782.patch";
      hash = "sha256-i/9m/ipF+yc2iMNoNWH4i2myUOilyKNqP2A5zWkCJaQ=";
    })
  ];

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
  ];

  buildInputs = [
    corrosion
    libuuid
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
    ];
    mainProgram = "task";
    platforms = lib.platforms.unix;
  };
})
