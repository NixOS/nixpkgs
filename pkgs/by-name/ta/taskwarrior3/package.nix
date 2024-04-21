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
  gnutls,
  python3,
  xdg-utils,
  installShellFiles,
  darwin,
}:
stdenv.mkDerivation rec {
  pname = "taskwarrior";
  version = "3.0.1";
  src = fetchFromGitHub {
    owner = "GothenburgBitFactory";
    repo = "taskwarrior";
    rev = "v3.0.1";
    hash = "sha256-S6aKFzdz7q06AtEc+QS9pXtjcExFqdvnTIs6mIOdXs8=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace src/commands/CmdNews.cpp \
      --replace "xdg-open" "${lib.getBin xdg-utils}/bin/xdg-open"
  '';

  nativeBuildInputs = [
    cmake
    libuuid
    python3
    installShellFiles
    corrosion
    cargo
    rustc
    rustPlatform.cargoSetupHook
  ] ++ lib.optionals stdenv.isDarwin [
    # darwin dependencies
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  doCheck = true;
  preCheck = ''
    patchShebangs --build test
  '';
  checkTarget = "test";

  cargoDeps = rustPlatform.fetchCargoTarball {
    name = "${pname}-${version}-cargo-deps";
    inherit src;
    sourceRoot = src.name;
    hash = "sha256-frWr0NwcJxdHFuRGZuHFOvbNp8Vd55fsBzj50dyWjk8=";
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

  meta = with lib; {
    description = "Highly flexible command-line tool to manage TODO lists";
    homepage = "https://taskwarrior.org";
    license = licenses.mit;
    maintainers = with maintainers; [marcweber oxalica mlaradji];
    mainProgram = "task";
    platforms = platforms.unix;
  };
}
