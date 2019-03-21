{ stdenv, fetchurl, bash, perl }:

stdenv.mkDerivation rec {
  name = "libfaketime-${version}";
  version = "0.9.7";

  src = fetchurl {
    url = "https://github.com/wolfcw/libfaketime/archive/v${version}.tar.gz";
    sha256 = "07l189881q0hybzmlpjyp7r5fwz23iafkm957bwy4gnmn9lg6rad";
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

  preBuild = ''
    makeFlagsArray+=(PREFIX="$out" LIBDIRNAME=/lib)
  '';

  checkInputs = [ perl ];

  meta = with stdenv.lib; {
    description = "Report faked system time to programs without having to change the system-wide time";
    homepage = "https://github.com/wolfcw/libfaketime/";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = [ maintainers.bjornfor ];
  };
}
