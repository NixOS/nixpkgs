{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libfaketime-0.9.6";

  src = fetchurl {
    url = "http://www.code-wizards.com/projects/libfaketime/${name}.tar.gz";
    sha256 = "1dw2lqsv2iqwxg51mdn25b4fjj3v357s0mc6ahxawqp210krg29s";
  };

  patches = [
    ./no-date-in-gzip-man-page.patch
  ];

  preBuild = ''
    makeFlagsArray+=(PREFIX="$out" LIBDIRNAME=/lib)
  '';

  # Work around "libfaketime.c:513:7: error: nonnull argument 'buf' compared to NULL [-Werror=nonnull-compare]".
  NIX_CFLAGS_COMPILE = "-Wno-nonnull-compare";

  meta = with stdenv.lib; {
    description = "Report faked system time to programs without having to change the system-wide time";
    homepage = http://www.code-wizards.com/projects/libfaketime/;
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = [ maintainers.bjornfor ];
  };
}
