{stdenv, fetchurl}:

stdenv.mkDerivation (rec {
  name = "libdaemon-0.14";

  src = fetchurl {
    url = "${meta.homepage}/${name}.tar.gz";
    sha256 = "0d5qlq5ab95wh1xc87rqrh1vx6i8lddka1w3f1zcqvcqdxgyn8zx";
  };

  configureFlags = [ "--disable-lynx" ]
    ++ stdenv.lib.optional (stdenv.hostPlatform != stdenv.buildPlatform)
    [ # Can't run this test while cross-compiling
      "ac_cv_func_setpgrp_void=yes"
    ];

  meta = {
    description = "Lightweight C library that eases the writing of UNIX daemons";

    homepage = http://0pointer.de/lennart/projects/libdaemon/;

    license = stdenv.lib.licenses.lgpl2Plus;

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ ];
  };
} // stdenv.lib.optionalAttrs stdenv.hostPlatform.isMusl {
  # This patch should be applied unconditionally, but doing so will cause mass rebuild.
  patches = ./fix-includes.patch;
})

