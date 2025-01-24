{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "zsync";
  version = "0.6.2";

  src = fetchurl {
    url = "http://zsync.moria.org.uk/download/zsync-${version}.tar.bz2";
    hash = "sha256-C51TQzOHqk8EY0psY6XvqCAwcPIpivcqcF+b492mWvI=";
  };

  env = lib.optionalAttrs stdenv.cc.isClang {
    # Suppress error "call to undeclared library function 'strcasecmp'" during compilation.
    # The function is found by the linker correctly, so this doesn't introduce any issues.
    NIX_CFLAGS_COMPILE = " -Wno-implicit-function-declaration";
  };

  makeFlags = [ "AR=${stdenv.cc.bintools.targetPrefix}ar" ];

  meta = with lib; {
    homepage = "http://zsync.moria.org.uk/";
    description = "File distribution system using the rsync algorithm";
    license = licenses.artistic2;
    maintainers = with maintainers; [ viric ];
    platforms = with platforms; all;
  };
}
