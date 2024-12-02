{ lib, stdenv, bsdbuild, libagar, perl, libjpeg, libpng, openssl }:

stdenv.mkDerivation {
  pname = "libagar-test";
  inherit (libagar) version src;

  sourceRoot = "agar-${libagar.version}/tests";

  # Workaround build failure on -fno-common toolchains:
  #   ld: textdlg.o:(.bss+0x0): multiple definition of `someString';
  #     configsettings.o:(.bss+0x0): first defined here
  # TODO: the workaround can be removed once nixpkgs updates to 1.6.0.
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  preConfigure = ''
    substituteInPlace configure.in \
      --replace '_BSD_SOURCE' '_DEFAULT_SOURCE'
    cat configure.in | ${bsdbuild}/bin/mkconfigure > configure
  '';

  configureFlags = [ "--with-agar=${libagar}" ];

  buildInputs = [ perl bsdbuild libagar libjpeg libpng openssl ];

  meta = with lib; {
    broken = (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);
    description = "Tests for libagar";
    mainProgram = "agartest";
    homepage = "http://libagar.org/index.html";
    license = with licenses; bsd3;
    maintainers = with maintainers; [ ramkromberg ];
    platforms = with platforms; linux;
  };
}
