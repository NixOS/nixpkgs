{ stdenv, fetchurl, libgcrypt, curl, gnutls, pkgconfig }:

stdenv.mkDerivation rec {
  name = "libmicrohttpd-0.9.50";

  src = fetchurl {
    url = "mirror://gnu/libmicrohttpd/${name}.tar.gz";
    sha256 = "1mzbqr6sqisppz88mh73bbh5sw57g8l87qvhcjdx5pmbd183idni";
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

    maintainers = [ maintainers.eelco maintainers.vrthra ];
    platforms = platforms.linux;
  };
}
