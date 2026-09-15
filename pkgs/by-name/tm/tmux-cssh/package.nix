{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  tmux,
}:

stdenv.mkDerivation {
  pname = "tmux-cssh";
  version = "0-unstable-2024-07-31";

  src = fetchFromGitHub {
    owner = "zinic";
    repo = "tmux-cssh";
    rev = "2841d12a20e15a3a7778e3b0d9222889a12173b1";
    hash = "sha256-4w4P4ss6ou6CfHDMsgVRiOF+/xLxINzS0Qu79LXW1X4=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp tmux-cssh $out/bin/tmux-cssh
    wrapProgram $out/bin/tmux-cssh --suffix PATH : ${tmux}/bin
  '';

  meta = {
    homepage = "https://github.com/zinic/tmux-cssh";
    description = "SSH to multiple hosts at the same time using tmux";

    longDescription = ''
      tmux is a terminal multiplexer, like e.g. screen, which gives you a
      possibility to use multiple virtual terminal session within one real
      terminal session. tmux-cssh (tmux-cluster-ssh) sets a comfortable and
      easy to use functionality, clustering and synchronizing virtual
      tmux-sessions, on top of tmux. No need for a x-server or x-forwarding.
      tmux-cssh works just with tmux and in an low-level terminal-environment,
      like most server do.
    '';

    license = lib.licenses.asl20;

    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ zimbatm ];
    mainProgram = "tmux-cssh";
  };
}
