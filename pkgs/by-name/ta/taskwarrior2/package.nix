{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  libuuid,
  gnutls,
  python3,
  xdg-utils,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "taskwarrior";
  version = "2.6.2";

  src = fetchFromGitHub {
    owner = "GothenburgBitFactory";
    repo = "taskwarrior";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0YveqiylXJi4cdDCfnPtwCVOJbQrZYsxnXES+9B4Yfw=";
    fetchSubmodules = true;
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/GothenburgBitFactory/libshared/commit/bde76fb717c8e56e5859472ba1e890abc5b94e63.patch";
      sha256 = "sha256-6esIya9VATtDbL3jOpXZtvMoIJ8ztznqUju4d4lE49w=";
      stripLen = 1;
      extraPrefix = "src/libshared/";
    })
  ];

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

  cmakeFlags = [
    # Fix build with cmake>=4
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
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

  meta = {
    description = "Highly flexible command-line tool to manage TODO lists";
    homepage = "https://taskwarrior.org";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      marcweber
      oxalica
      Necior
    ];
    mainProgram = "task";
    platforms = lib.platforms.unix;
  };
})
