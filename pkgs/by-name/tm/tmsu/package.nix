{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule {
  pname = "tmsu";
  version = "0.7.5-unstable-2024-06-08";

  src = fetchFromGitHub {
    owner = "oniony";
    repo = "tmsu";
    rev = "0bf4b8031cbeffc0347007d85647062953e90571";
    sha256 = "sha256-5Rmelgiqs7YkdDBZNXZW4sBf0l/bwiq0xxB2tWpm1s8=";
  };

  vendorHash = "sha256-r2wzVkPTsxWdVPFLO84tJgl3VJonoU7kNKLOBgHHdF8=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    # can't do "mv TMSU tmsu" on case-insensitive filesystems
    mv $out/bin/{TMSU,tmsu.tmp}
    mv $out/bin/{tmsu.tmp,tmsu}

    installManPage misc/man/tmsu.1
    installShellCompletion --bash misc/bash/tmsu
    installShellCompletion --zsh misc/zsh/_tmsu
  '';

  meta = {
    homepage = "https://www.tmsu.org";
    description = "Tool for tagging your files using a virtual filesystem";
    maintainers = with lib.maintainers; [
      luftmensch-luftmensch
      pSub
    ];
    mainProgram = "tmsu";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
  };
}
