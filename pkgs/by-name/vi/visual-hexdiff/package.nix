{
  stdenv,
  lib,
  fetchurl,
  fetchpatch,
  ncurses,
}:
stdenv.mkDerivation {
  pname = "visual-hexdiff";
  version = "0.0.53";

  src = fetchurl {
    url = "mirror://ubuntu/pool/universe/h/hexdiff/hexdiff_0.0.53.orig.tar.gz";
    sha256 = "sha256-M1bmkW63pHlfl9zNWEq0EGN1rpVGo+BTUKM9ot4HWqo=";
  };
# Fix compiler error that wants a string literal as format string for `wprintw`
  prePatch = ''
    substituteInPlace sel_file.c \
      --replace 'wprintw(win, txt_aide_fs[foo]);' 'wprintw(win, "%s", txt_aide_fs[foo]);'
  '';

  patches = [
    # Some changes the debian/ubuntu developers made over the original source code
    (fetchpatch {
      url = "mirror://ubuntu/pool/universe/h/hexdiff/hexdiff_0.0.53-0ubuntu4.diff.gz";
      sha256 = "sha256-X5ONNp9jeACxsulyowDQJ6REX6bty6L4in0/+rq8Wz4=";
      decode = "gunzip --stdout";
      name = "hexdiff_0.0.53-0ubuntu4.diff";
      stripLen = 1;
    })
  ];

  buildInputs = [ ncurses ];

  preInstall = ''
    mkdir -p $out/bin/
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Visual hexadecimal difference editor";
    homepage = "http://tboudet.free.fr/hexdiff/";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ erictapen ];
    mainProgram = "hexdiff";
    platforms = platforms.all;
  };

}
