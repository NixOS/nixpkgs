{
  lib,
  stdenv,
  libgcrypt,
  curl,
  gnutls,
  pkg-config,
  libiconv,
  libintl,
  version,
  src,
  meta ? { },
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmicrohttpd";
  inherit version src;

  outputs = [
    "out"
    "dev"
    "devdoc"
    "info"
  ];
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libgcrypt
    curl
    gnutls
    libiconv
    libintl
  ];

  enableParallelBuilding = true;

  preCheck = ''
    # Since `localhost' can't be resolved in a chroot, work around it.
    sed -i -e 's/localhost/127.0.0.1/g' src/test*/*.[ch]
  '';

  # Disabled because the tests can time-out.
  doCheck = false;

  meta =
<<<<<<< HEAD

=======
    with lib;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    {
      description = "Embeddable HTTP server library";

      longDescription = ''
        GNU libmicrohttpd is a small C library that is supposed to make
        it easy to run an HTTP server as part of another application.
      '';

<<<<<<< HEAD
      license = lib.licenses.lgpl2Plus;

      homepage = "https://www.gnu.org/software/libmicrohttpd/";

      maintainers = with lib.maintainers; [ fpletz ];
      platforms = lib.platforms.unix;
=======
      license = licenses.lgpl2Plus;

      homepage = "https://www.gnu.org/software/libmicrohttpd/";

      maintainers = with maintainers; [ fpletz ];
      platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    }
    // meta;
})
