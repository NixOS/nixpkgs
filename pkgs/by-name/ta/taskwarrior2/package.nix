{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libuuid,
  gnutls,
  python3,
  xdg-utils,
  installShellFiles,
}:

stdenv.mkDerivation rec {
  pname = "taskwarrior";
  version = "2.6.2";

  src = fetchFromGitHub {
    owner = "GothenburgBitFactory";
    repo = "taskwarrior";
    rev = "v${version}";
    hash = "sha256-0YveqiylXJi4cdDCfnPtwCVOJbQrZYsxnXES+9B4Yfw=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace src/commands/CmdNews.cpp \
      --replace "xdg-open" "${lib.getBin xdg-utils}/bin/xdg-open"
  '';

  nativeBuildInputs = [
    cmake
    libuuid
    gnutls
    python3
    installShellFiles
  ];

  doCheck = true;
  preCheck = ''
    patchShebangs --build test
  '';
  checkTarget = "test";

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
    maintainers = with maintainers; [
      marcweber
      oxalica
    ];
    mainProgram = "task";
    platforms = platforms.unix;
  };
}
