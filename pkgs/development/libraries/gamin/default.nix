{ stdenv, fetchurl, python, pkgconfig, glib }:

stdenv.mkDerivation (rec {
  name = "gamin-0.1.10";

  src = fetchurl {
    url = "http://www.gnome.org/~veillard/gamin/sources/${name}.tar.gz";
    sha256 = "18cr51y5qacvs2fc2p1bqv32rs8bzgs6l67zhasyl45yx055y218";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ python glib ];

  # `_GNU_SOURCE' is needed, e.g., to get `struct ucred' from
  # <sys/socket.h> with Glibc 2.9.
  configureFlags = "--disable-debug --with-python=${python} CPPFLAGS=-D_GNU_SOURCE";

  patches = [ ./deadlock.patch ] ++ map fetchurl (import ./debian-patches.nix);


  meta = with stdenv.lib; {
    homepage    = https://people.gnome.org/~veillard/gamin/;
    description = "A file and directory monitoring system";
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };
}

// stdenv.lib.optionalAttrs stdenv.isDarwin {
  preBuild =  ''
    sed -i 's/,--version-script=.*$/\\/' libgamin/Makefile
  '';
})

