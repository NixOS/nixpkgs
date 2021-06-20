{lib, stdenv, fetchurl}:

stdenv.mkDerivation rec {
  pname = "libantlr3c";
  version = "3.4";
  src = fetchurl {
    url = "https://www.antlr3.org/download/C/libantlr3c-${version}.tar.gz";
    sha256 ="0lpbnb4dq4azmsvlhp6khq1gy42kyqyjv8gww74g5lm2y6blm4fa";
  };

  configureFlags = lib.optional stdenv.is64bit "--enable-64bit";

  meta = with lib; {
    description = "C runtime libraries of ANTLR v3";
    homepage = "https://www.antlr3.org/";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ vbgl ];
    # The package failed to build with error:
    #   gcc: error: unrecognized command line option '-m64'
    #
    # See:
    # https://gist.github.com/r-rmcgibbo/15bf2ca9b297e8357887e146076fff7d
    # https://gist.github.com/r-rmcgibbo/a362535e4b174d4bfb68112503a49fcd
    broken = stdenv.hostPlatform.isAarch64;
  };
}
