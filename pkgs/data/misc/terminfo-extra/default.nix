{ rxvt_unicode, st, runCommandNoCC, ncurses }:
runCommandNoCC "terminfo-extra" {
  nativeBuildInputs = [ ncurses ];
  srcs = [ rxvt_unicode.src st.src ];
  sourceRoot = ".";
} ''
  unpackPhase

  mkdir -p $out/share/terminfo
  tic -xo $out/share/terminfo */doc/etc/rxvt-unicode.terminfo
  tic -xo $out/share/terminfo */st.info
''
