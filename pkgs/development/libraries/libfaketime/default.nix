{ lib, stdenv, fetchurl, perl, coreutils }:

stdenv.mkDerivation rec {
  pname = "libfaketime";
  version = "0.9.9";

  src = fetchurl {
    url = "https://github.com/wolfcw/libfaketime/archive/v${version}.tar.gz";
    sha256 = "sha256-V9AYEVA2HAqbXI7vBbETkvYTStosLZmOkuY9rtY5ZHw=";
  };

  patches = [
    ./no-date-in-gzip-man-page.patch
    ./nix-store-date.patch
  ] ++ (lib.optionals stdenv.cc.isClang [
    # https://github.com/wolfcw/libfaketime/issues/277
    ./0001-Remove-unsupported-clang-flags.patch
  ]);

  postPatch = ''
    patchShebangs test src
    for a in test/functests/test_exclude_mono.sh src/faketime.c ; do
      substituteInPlace $a \
        --replace /bin/bash ${stdenv.shell}
    done
    substituteInPlace src/faketime.c --replace @DATE_CMD@ ${coreutils}/bin/date
  '';

  PREFIX = placeholder "out";
  LIBDIRNAME = "/lib";

  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-error=cast-function-type -Wno-error=format-truncation";

  checkInputs = [ perl ];

  meta = with lib; {
    description = "Report faked system time to programs without having to change the system-wide time";
    homepage = "https://github.com/wolfcw/libfaketime/";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = [ maintainers.bjornfor ];
    mainProgram = "faketime";
  };
}
