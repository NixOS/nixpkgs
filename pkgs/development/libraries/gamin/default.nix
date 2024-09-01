{ lib, stdenv, fetchurl, fetchpatch, pkg-config, glib, autoreconfHook }:

stdenv.mkDerivation (finalAttrs: {
  pname = "gamin";
  version = "0.1.10";

  src = fetchurl {
    url = "mirror://gnome/sources/gamin/${lib.versions.majorMinor finalAttrs.version}/gamin-${finalAttrs.version}.tar.gz";
    hash = "sha256-KAhfCui+EOq1gv8YavT7C+ksxsYrXMGc0JspXHwomaE=";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ];

  buildInputs = [ glib ];

  # `_GNU_SOURCE' is needed, e.g., to get `struct ucred' from
  # <sys/socket.h> with Glibc 2.9.
  configureFlags = [
    "--disable-debug"
    "--without-python" # python3 not supported
    "CPPFLAGS=-D_GNU_SOURCE"
  ];

  preBuild = lib.optionalString stdenv.isDarwin ''
    sed -i 's/,--version-script=.*$/\\/' libgamin/Makefile
  '';

  env = lib.optionalAttrs stdenv.cc.isClang {
    NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";
  };

  patches = [ ./deadlock.patch ]
    ++ map fetchurl (import ./debian-patches.nix)
    ++ lib.optional stdenv.cc.isClang ./returnval.patch
    ++ lib.optional stdenv.hostPlatform.isMusl (fetchpatch {
      name = "fix-pthread-mutex.patch";
      url = "https://git.alpinelinux.org/aports/plain/main/gamin/fix-pthread-mutex.patch?h=3.4-stable&id=a1a836b089573752c1b0da7d144c0948b04e8ea8";
      sha256 = "13igdbqsxb3sz0h417k6ifmq2n4siwqspj6slhc7fdl5wd1fxmdz";
    }) ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) ./abstract-socket-namespace.patch;


  meta = with lib; {
    homepage    = "https://gitlab.gnome.org/Archive/gamin";
    description = "File and directory monitoring system";
    maintainers = with maintainers; [ lovek323 ];
    license = licenses.gpl2;
    platforms   = platforms.unix;
  };
})

