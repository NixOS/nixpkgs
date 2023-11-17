{ lib
, stdenv
, fetchurl
, enableShared ? !stdenv.hostPlatform.isStatic
, windows
}:

stdenv.mkDerivation (finalAttrs: {
  version = "4.13.0";
  pname = "libpfm";

  src = fetchurl {
    url = "mirror://sourceforge/perfmon2/libpfm4/libpfm-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-0YuXdkx1VSjBBR03bjNUXQ62DG6/hWgENoE/pbBMw9E=";
  };

  # Don't install libpfm.so on windows as it doesn't exist
  # This target is created only if `ifeq ($(SYS),Linux)` passes
  patches = [ ./fix-windows.patch ];

  # Upstream uses "WINDOWS" instead of "Windows" which is incorrect
  # See: https://github.com/NixOS/nixpkgs/pull/252982#discussion_r1314346216
  postPatch = ''
    substituteInPlace config.mk examples/Makefile \
      --replace '($(SYS),WINDOWS)' '($(SYS),Windows)'
  '';

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "LDCONFIG=true"
    "ARCH=${stdenv.hostPlatform.uname.processor}"
    "SYS=${stdenv.hostPlatform.uname.system}"
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error";
  env.CONFIG_PFMLIB_SHARED = if enableShared then "y" else "n";

  buildInputs = lib.optional stdenv.hostPlatform.isWindows windows.libgnurx;

  meta = with lib; {
    description = "Helper library to program the performance monitoring events";
    longDescription = ''
      This package provides a library, called libpfm4 which is used to
      develop monitoring tools exploiting the performance monitoring
      events such as those provided by the Performance Monitoring Unit
      (PMU) of modern processors.
    '';
    license = licenses.gpl2;
    maintainers = with maintainers; [ pierron t4ccer ];
    platforms = platforms.linux ++ platforms.windows;
  };
})
