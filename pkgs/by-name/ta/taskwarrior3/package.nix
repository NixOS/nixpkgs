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

  # passthru.tests
  nixosTests,

  # nativeCheckInputs
  python3,

  # nativeInstallCheckInputs
  versionCheckHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "taskwarrior";
  version = "3.4.1";
  src = fetchFromGitHub {
    owner = "GothenburgBitFactory";
    repo = "taskwarrior";
    tag = "v${finalAttrs.version}";
    hash = "sha256-00HiGju4pIswx8Z+M+ATdBSupiMS2xIm2ZnE52k/RwA=";
    fetchSubmodules = true;
  };
  cargoDeps = rustPlatform.fetchCargoVendor {
    name = "${finalAttrs.pname}-${finalAttrs.version}-cargo-deps";
    inherit (finalAttrs) src;
    hash = "sha256-trc5DIWf68XRBSMjeG/ZchuwFA56wJnLbqm17gE+jYQ=";
  };

  # The CMakeLists files used by upstream issue a `cargo install` command to
  # install a rust tool (cxxbridge-cmd) that is supposed to be included in the Cargo.toml's and
  # `Cargo.lock` files of upstream. Setting CARGO_HOME like that helps `cargo
  # install` find the dependencies we prefetched. See also:
  # https://github.com/GothenburgBitFactory/taskwarrior/issues/3705
  postUnpack = ''
    export CARGO_HOME=$PWD/.cargo
  '';
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
    libuuid
  ];

  doCheck = true;
  # See:
  # https://github.com/GothenburgBitFactory/taskwarrior/blob/v3.2.0/doc/devel/contrib/development.md#run-the-test-suite
  preCheck = ''
    make test_runner
  '';
  nativeCheckInputs = [
    python3
  ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  versionCheckProgram = "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}";

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
    changelog = "https://github.com/GothenburgBitFactory/taskwarrior/releases/tag/${finalAttrs.src.tag}";
    description = "Highly flexible command-line tool to manage TODO lists";
    homepage = "https://taskwarrior.org";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      marcweber
      oxalica
      mlaradji
      doronbehar
      Necior
    ];
    mainProgram = "task";
    platforms = lib.platforms.unix;
  };
})
