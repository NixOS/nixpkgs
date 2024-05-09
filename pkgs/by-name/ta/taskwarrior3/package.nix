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
    version = "3.0.0-unstable-2024-04-07";
    src = fetchFromGitHub {
      owner = "GothenburgBitFactory";
      repo = "taskwarrior";
      rev = "fd306712b85dda3ea89de4e617aebeb98b2ede80";
      fetchSubmodules = true;
      sha256 = "sha256-vzfHq/LHfnTx6CVGFCuO6W5aSqj1jVqldMdmyciSDDk=";
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
    hash = "sha256-zQca/1tI/GUCekKhrg2iSL+h69SH6Ttsj3MqwDKj8HQ=";
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
