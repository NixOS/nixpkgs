{
  lib,
  stdenv,
  fetchFromGitHub,

  # nativeBuildInputs
  cmake,
  rustPlatform,
  rustc,
  cargo,
  installShellFiles,

  # buildInputs
  libuuid,
  xdg-utils,

  # passthru.tests
  nixosTests,

  # nativeCheckInputs
  python3,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "taskwarrior";
  version = "3.2.0-unstable-2024-12-17";
  src = fetchFromGitHub {
    owner = "GothenburgBitFactory";
    repo = "taskwarrior";
    rev = "cc505e488184e958bcaedad6fed86f91d128e6bd";
    hash = "sha256-M9pRoilxTHppX/efvppBI+QiPYXBEkvWxiEnodjqryk=";
    fetchSubmodules = true;
  };
  cargoDeps = rustPlatform.fetchCargoTarball {
    name = "${finalAttrs.pname}-${finalAttrs.version}-cargo-deps";
    inherit (finalAttrs) src;
    hash = "sha256-QPnW+FWbsjvjQr5CRuOGLIaUWSGItlFDwLEtZfRbihA="; # For fetchCargoTarball with name arguments
  };

  postPatch = ''
    substituteInPlace src/commands/CmdNews.cpp \
      --replace-fail "xdg-open" "${lib.getBin xdg-utils}/bin/xdg-open"
  '';
  # The CMakeLists files used by upstream issue a `cargo install` command to
  # install a rust tool (cxxbridge-cmd) that is supposed to be included in the Cargo.toml's and
  # `Cargo.lock` files of upstream. Setting CARGO_HOME like that helps `cargo
  # install` find the dependencies we prefetched. See also:
  # https://github.com/GothenburgBitFactory/taskwarrior/issues/3705
  postUnpack = ''
    export CARGO_HOME=$PWD/.cargo
  '';
  # Test failures, see:
  # https://github.com/GothenburgBitFactory/taskwarrior/issues/3727
  failingTests = [
    "bash_completion.test.py"
    "hooks.env.test.py"
    "hooks.on-add.test.py"
    "hooks.on-launch.test.py"
    "hooks.on-modify.test.py"
    "hooks.on-exit.test.py"
  ];
  preConfigure = ''
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
    libuuid
  ];

  doCheck = true;
  preCheck = ''
    # See:
    # https://github.com/GothenburgBitFactory/taskwarrior/blob/v3.2.0/doc/devel/contrib/development.md#run-the-test-suite
    make test_runner
    # Otherwise all '/usr/bin/env python' shebangs are not found by ctest
    patchShebangs test/*.py test/*/*.py
  '';
  nativeCheckInputs = [
    python3
  ];

  postInstall = ''
    # ZSH is installed automatically from some reason, only bash and fish need
    # manual installation
    installShellCompletion --cmd task \
      --bash $out/share/doc/task/scripts/bash/task.sh \
      --fish $out/share/doc/task/scripts/fish/task.fish
    rm -r $out/share/doc/task/scripts/bash
    rm -r $out/share/doc/task/scripts/fish
    # Install vim and neovim plugin
    mkdir -p $out/share/vim-plugins
    mv $out/share/doc/task/scripts/vim $out/share/vim-plugins/task
    mkdir -p $out/share/nvim
    ln -s $out/share/vim-plugins/task $out/share/nvim/site
  '';

  passthru.tests.nixos = nixosTests.taskchampion-sync-server;

  meta = {
    changelog = "https://github.com/GothenburgBitFactory/taskwarrior/blob/${finalAttrs.src.rev}/ChangeLog";
    description = "Highly flexible command-line tool to manage TODO lists";
    homepage = "https://taskwarrior.org";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      marcweber
      oxalica
      mlaradji
      doronbehar
    ];
    mainProgram = "task";
    platforms = lib.platforms.unix;
  };
})
