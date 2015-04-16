{ stdenv, fetchcvs }:

stdenv.mkDerivation rec {
  name = "libffcall-${version}";
  version = "2009-05-27";
  src = fetchcvs {
    cvsRoot = ":pserver:anonymous@cvs.savannah.gnu.org:/sources/libffcall";
    module = "ffcall";
    date = version;
    sha256 = "097pv94495njppl9iy2yk47z5wdwvf7swsl88nmwrac51jibbg4i";
  };

  configurePhase = ''
    for i in ./configure */configure; do
      cwd="$PWD"
      cd "$(dirname "$i")";
      ( test -f Makefile && make distclean ) || true
      ./configure --prefix=$out
      cd "$cwd"
    done
  '';

  meta = {
    description = "Foreign function call library";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
  };
}
