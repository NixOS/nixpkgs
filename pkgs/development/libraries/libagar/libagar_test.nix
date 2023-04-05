{ lib, stdenv, fetchurl, bsdbuild, libagar, perl, libjpeg, libpng, openssl }:

let srcs = import ./srcs.nix { inherit fetchurl; }; in
stdenv.mkDerivation {
  pname = "libagar-test";
  inherit (srcs) version src;

  sourceRoot = "agar-1.5.0/tests";

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
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "Tests for libagar";
    homepage = "http://libagar.org/index.html";
    license = with licenses; bsd3;
    maintainers = with maintainers; [ ramkromberg ];
    platforms = with platforms; linux;
  };
}
