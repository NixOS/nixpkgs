{ stdenv, fetchurl, libgcrypt, curl, gnutls, pkgconfig }:

stdenv.mkDerivation rec {
  name = "libmicrohttpd-0.9.55";

  src = fetchurl {
    url = "mirror://gnu/libmicrohttpd/${name}.tar.gz";
    sha256 = "1y6h1slav5l6k8zyb01dpw65dscdgxxgfa3a0z9qnn7jr66sn70c";
  };

  outputs = [ "out" "dev" "devdoc" "info" ];
  buildInputs = [ libgcrypt curl gnutls pkgconfig ];

  preCheck = ''
    # Since `localhost' can't be resolved in a chroot, work around it.
    sed -ie 's/localhost/127.0.0.1/g' src/test*/*.[ch]
  '';

  # Disabled because the tests can time-out.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Embeddable HTTP server library";

    longDescription = ''
      GNU libmicrohttpd is a small C library that is supposed to make
      it easy to run an HTTP server as part of another application.
    '';

    license = licenses.lgpl2Plus;

    homepage = http://www.gnu.org/software/libmicrohttpd/;

    maintainers = with maintainers; [ eelco vrthra fpletz ];
    platforms = platforms.linux;
  };
}
