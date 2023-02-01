{ lib, stdenv, fetchFromGitHub, fetchpatch, perl, coreutils }:

stdenv.mkDerivation rec {
  pname = "libfaketime";
  version = "0.9.10";

  src = fetchFromGitHub {
    owner = "wolfcw";
    repo = "libfaketime";
    rev = "v${version}";
    sha256 = "sha256-DYRuQmIhQu0CNEboBAtHOr/NnWxoXecuPMSR/UQ/VIQ=";
  };

  patches = [
    ./nix-store-date.patch
    (fetchpatch {
      name = "0001-libfaketime.c-wrap-timespec_get-in-TIME_UTC-macro.patch";
      url = "https://github.com/wolfcw/libfaketime/commit/e0e6b79568d36a8fd2b3c41f7214769221182128.patch";
      sha256 = "sha256-KwwP76v0DXNW73p/YBvwUOPdKMAcVdbQSKexD/uFOYo=";
    })
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

  nativeCheckInputs = [ perl ];

  meta = with lib; {
    description = "Report faked system time to programs without having to change the system-wide time";
    homepage = "https://github.com/wolfcw/libfaketime/";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = [ maintainers.bjornfor ];
    mainProgram = "faketime";
  };
}
