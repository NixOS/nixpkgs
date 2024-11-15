{
  rustPlatform,
  rustc,
  cargo,
  corrosion,
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libuuid,
  nixosTests,
  python3,
  xdg-utils,
  installShellFiles,
  darwin,
}:
stdenv.mkDerivation rec {
  pname = "taskwarrior";
  version = "3.2.0";
  src = fetchFromGitHub {
    owner = "GothenburgBitFactory";
    repo = "taskwarrior";
    rev = "v${version}";
    hash = "sha256-zLD7B6Wtk/HcJO9VE/k96FVnnjHAFE9ZOoeSCp7EucE=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace src/commands/CmdNews.cpp \
      --replace "xdg-open" "${lib.getBin xdg-utils}/bin/xdg-open"
  '';

  nativeBuildInputs =
    [
      cmake
      libuuid
      python3
      installShellFiles
      corrosion
      cargo
      rustc
      rustPlatform.cargoSetupHook
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # darwin dependencies
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  doCheck = true;
  checkTarget = "build_tests";

  cargoDeps = rustPlatform.fetchCargoTarball {
    name = "${pname}-${version}-cargo-deps";
    inherit src;
    sourceRoot = src.name;
    hash = "sha256-sWhoT5iQHMtextJ+lZP6BroAbGYTAtm+YxXjTmyfKXw=";
  };
  cargoRoot = "./";
  preConfigure = ''
    export CMAKE_PREFIX_PATH="${corrosion}:$CMAKE_PREFIX_PATH"
  '';

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
    changelog = "https://github.com/GothenburgBitFactory/taskwarrior/blob/${src.rev}/ChangeLog";
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
}
