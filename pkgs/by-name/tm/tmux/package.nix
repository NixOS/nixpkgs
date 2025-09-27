{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  bison,
  libevent,
  ncurses,
  pkg-config,
  runCommand,
  withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
  systemd,
  # broken on i686-linux https://github.com/tmux/tmux/issues/4597
  withUtf8proc ? !(stdenv.hostPlatform.is32bit),
  utf8proc, # gets Unicode updates faster than glibc
  withUtempter ? stdenv.hostPlatform.isLinux && !stdenv.hostPlatform.isMusl,
  libutempter,
  withSixel ? true,
}:

let

  bashCompletion = fetchFromGitHub {
    owner = "imomaliev";
    repo = "tmux-bash-completion";
    rev = "f5d53239f7658f8e8fbaf02535cc369009c436d6";
    sha256 = "0sq2g3w0h3mkfa6qwqdw93chb5f1hgkz5vdl8yw8mxwdqwhsdprr";
  };

in

stdenv.mkDerivation (finalAttrs: {
  pname = "tmux";
  version = "3.5a";

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "tmux";
    repo = "tmux";
    rev = finalAttrs.version;
    hash = "sha256-Z9XHpyh4Y6iBI4+SfFBCGA8huFJpRFZy9nEB7+WQVJE=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    bison
  ];

  buildInputs = [
    ncurses
    libevent
  ]
  ++ lib.optionals withSystemd [ systemd ]
  ++ lib.optionals withUtf8proc [ utf8proc ]
  ++ lib.optionals withUtempter [ libutempter ];

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ]
  ++ lib.optionals withSystemd [ "--enable-systemd" ]
  ++ lib.optionals withSixel [ "--enable-sixel" ]
  ++ lib.optionals withUtempter [ "--enable-utempter" ]
  ++ lib.optionals withUtf8proc [ "--enable-utf8proc" ];

  enableParallelBuilding = true;

  postInstall = ''
    mkdir -p $out/share/bash-completion/completions
    cp -v ${bashCompletion}/completions/tmux $out/share/bash-completion/completions/tmux
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir $out/nix-support
    echo "${finalAttrs.passthru.terminfo}" >> $out/nix-support/propagated-user-env-packages
  '';

  passthru = {
    terminfo = runCommand "tmux-terminfo" { nativeBuildInputs = [ ncurses ]; } (
      if stdenv.hostPlatform.isDarwin then
        ''
          mkdir -p $out/share/terminfo/74
          cp -v ${ncurses}/share/terminfo/74/tmux $out/share/terminfo/74
          # macOS ships an old version (5.7) of ncurses which does not include tmux-256color so we need to provide it from our ncurses.
          # However, due to a bug in ncurses 5.7, we need to first patch the terminfo before we can use it with macOS.
          # https://gpanders.com/blog/the-definitive-guide-to-using-tmux-256color-on-macos/
          tic -o $out/share/terminfo -x <(TERMINFO_DIRS=${ncurses}/share/terminfo infocmp -x tmux-256color | sed 's|pairs#0x10000|pairs#32767|')
        ''
      else
        ''
          mkdir -p $out/share/terminfo/t
          ln -sv ${ncurses}/share/terminfo/t/{tmux,tmux-256color,tmux-direct} $out/share/terminfo/t
        ''
    );
  };

  meta = {
    homepage = "https://tmux.github.io/";
    description = "Terminal multiplexer";
    longDescription = ''
      tmux is intended to be a modern, BSD-licensed alternative to programs such as GNU screen. Major features include:
        * A powerful, consistent, well-documented and easily scriptable command interface.
        * A window may be split horizontally and vertically into panes.
        * Panes can be freely moved and resized, or arranged into preset layouts.
        * Support for UTF-8 and 256-colour terminals.
        * Copy and paste with multiple buffers.
        * Interactive menus to select windows, sessions or clients.
        * Change the current window by searching for text in the target.
        * Terminal locking, manually or after a timeout.
        * A clean, easily extended, BSD-licensed codebase, under active development.
    '';
    changelog = "https://github.com/tmux/tmux/raw/${finalAttrs.version}/CHANGES";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    mainProgram = "tmux";
    maintainers = with lib.maintainers; [
      thammers
      fpletz
    ];
  };
})
