{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libevent,
  libtirpc,
}:

stdenv.mkDerivation {
  pname = "trickle";
  version = "1.07-unstable-2019-10-03";

  src = fetchFromGitHub {
    owner = "mariusae";
    repo = "trickle";
    rev = "09a1d955c6554eb7e625c99bf96b2d99ec7db3dc";
    sha256 = "sha256-cqkNPeTo+noqMCXsxh6s4vKoYwsWusafm/QYX8RvCek=";
  };

  patches = [
    ./trickle-gcc14.patch
    ./atomicio.patch
    ./remove-libtrickle.patch
  ];

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    libevent
    libtirpc
  ];

  preAutoreconf = ''
    sed -i -e 's|\s*LIBCGUESS=.*|LIBCGUESS=${stdenv.cc.libc}/lib/libc.so.*|' configure.in
    grep LIBCGUESS configure.in
    sed -i 's|libevent.a|libevent.so|' configure.in
  '';

  preBuild = ''
    sed -i '/#define in_addr_t/ s:^://:' config.h
    sed -i 's|^_select(int|select(int|' trickle-overload.c
  '';

  NIX_LDFLAGS = [
    "-levent"
    "-ltirpc"
  ];
  env.NIX_CFLAGS_COMPILE = toString [
    "-I${libtirpc.dev}/include/tirpc"
    "-Wno-error=incompatible-pointer-types"
  ];

  configureFlags = [ "--with-libevent" ];

  hardeningDisable = [ "format" ];

  meta = {
    description = "Lightweight userspace bandwidth shaper";
    license = lib.licenses.bsd3;
    homepage = "https://monkey.org/~marius/pages/?page=trickle";
    platforms = lib.platforms.linux;
    mainProgram = "trickle";
  };
}
