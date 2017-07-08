{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, libconfuse }:

stdenv.mkDerivation rec {
  name = "libite-${version}";
  version = "1.8.3";

  src = fetchFromGitHub {
    owner = "troglobit";
    repo = "libite";
    rev = "v${version}";
    sha256 = "040idgbjqr239rkd68rqzwhylryiaa0z3qkwj2l2mlscv0aq8v0j";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ libconfuse ];

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Lightweight library of frog DNA";
    longDescription = ''
      Libite is a lightweight library of frog DNA. It can be used to fill
      the gaps in any dinosaur project. It holds useful functions and macros
      developed by both Finit and the OpenBSD project. Most notably the
      string functions: strlcpy(3), strlcat(3) and the highly useful *BSD
      sys/queue.h and sys/tree.h API's.

      Libite is the frog DNA missing in GNU libc. However, -lite does not
      aim to become another GLIB! One noticeable gap in GLIBC is the missing
      _SAFE macros in the BSD sys/queue.h API — highly recommended when
      traversing lists to delete/free nodes.
    '';
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz ];
  };
}

