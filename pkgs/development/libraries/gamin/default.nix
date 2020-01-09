{ stdenv, fetchurl, fetchpatch, pkgconfig, glib }:

stdenv.mkDerivation (rec {
  name = "gamin-0.1.10";

  src = fetchurl {
    url = "https://www.gnome.org/~veillard/gamin/sources/${name}.tar.gz";
    sha256 = "18cr51y5qacvs2fc2p1bqv32rs8bzgs6l67zhasyl45yx055y218";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ glib ];

  # `_GNU_SOURCE' is needed, e.g., to get `struct ucred' from
  # <sys/socket.h> with Glibc 2.9.
  configureFlags = [
    "--disable-debug"
    "--without-python" # python3 not supported
    "CPPFLAGS=-D_GNU_SOURCE"
  ];

  patches = [ ./deadlock.patch ]
    ++ map fetchurl (import ./debian-patches.nix)
    ++ stdenv.lib.optional stdenv.cc.isClang ./returnval.patch
    ++ stdenv.lib.optional stdenv.hostPlatform.isMusl (fetchpatch {
      name = "fix-pthread-mutex.patch";
      url = "https://git.alpinelinux.org/cgit/aports/plain/main/gamin/fix-pthread-mutex.patch?h=3.4-stable&id=a1a836b089573752c1b0da7d144c0948b04e8ea8";
      sha256 = "13igdbqsxb3sz0h417k6ifmq2n4siwqspj6slhc7fdl5wd1fxmdz";
    });


  meta = with stdenv.lib; {
    homepage    = https://people.gnome.org/~veillard/gamin/;
    description = "A file and directory monitoring system";
    maintainers = with maintainers; [ lovek323 ];
    license = licenses.gpl2;
    platforms   = platforms.unix;
  };
}

// stdenv.lib.optionalAttrs stdenv.isDarwin {
  preBuild =  ''
    sed -i 's/,--version-script=.*$/\\/' libgamin/Makefile
  '';
})
