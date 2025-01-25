{
  lib,
  stdenv,
  fetchurl,
  libevent,
  libtirpc,
}:

stdenv.mkDerivation rec {
  pname = "trickle";
  version = "1.07";

  src = fetchurl {
    url = "https://monkey.org/~marius/trickle/trickle-${version}.tar.gz";
    sha256 = "0s1qq3k5mpcs9i7ng0l9fvr1f75abpbzfi1jaf3zpzbs1dz50dlx";
  };

  buildInputs = [
    libevent
    libtirpc
  ];

  preConfigure = ''
    sed -i 's|libevent.a|libevent.so|' configure
  '';

  preBuild = ''
    sed -i '/#define in_addr_t/ s:^://:' config.h
  '';

  NIX_LDFLAGS = [
    "-levent"
    "-ltirpc"
  ];
  env.NIX_CFLAGS_COMPILE = toString [ "-I${libtirpc.dev}/include/tirpc" ];

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
