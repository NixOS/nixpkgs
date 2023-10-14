{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, libconfuse }:

stdenv.mkDerivation rec {
  pname = "libite";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "troglobit";
    repo = "libite";
    rev = "v${version}";
    sha256 = "sha256-hdV8g/BFTI/QfEgVsf942SR0G5xdqP/+h+vnydt4kf0=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ libconfuse ];

  meta = with lib; {
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
    homepage = "https://github.com/troglobit/libite";
    platforms = with platforms; linux ++ netbsd;
    maintainers = with maintainers; [ fpletz ];
    license = with licenses; [ mit isc bsd2 bsd3 ];
  };
}

