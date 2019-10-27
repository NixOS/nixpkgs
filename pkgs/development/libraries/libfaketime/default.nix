{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  pname = "libfaketime";
  version = "0.9.8";

  src = fetchurl {
    url = "https://github.com/wolfcw/libfaketime/archive/v${version}.tar.gz";
    sha256 = "18s2hjm4sbrlg6sby944z87yslnq9s85p7j892hyr42qrlvq4a06";
  };

  patches = [
    ./no-date-in-gzip-man-page.patch
  ];

  postPatch = ''
    patchShebangs test src
    for a in test/functests/test_exclude_mono.sh src/faketime.c ; do
      substituteInPlace $a \
        --replace /bin/bash ${stdenv.shell}
    done
  '';

  PREFIX = placeholder "out";
  LIBDIRNAME = "/lib";

  NIX_CFLAGS_COMPILE = "-Wno-error=cast-function-type -Wno-error=format-truncation";

  checkInputs = [ perl ];

  meta = with stdenv.lib; {
    description = "Report faked system time to programs without having to change the system-wide time";
    homepage = "https://github.com/wolfcw/libfaketime/";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = [ maintainers.bjornfor ];
  };
}
