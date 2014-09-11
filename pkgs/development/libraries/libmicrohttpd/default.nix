{stdenv, fetchurl, curl, libgcrypt}:

stdenv.mkDerivation rec {
  name = "libmicrohttpd-0.9.37";

  src = fetchurl {
    url = "mirror://gnu/libmicrohttpd/${name}.tar.gz";
    sha256 = "1p3wnhr43v6vqdgl86r76298wjfxz2ihj9zh9kpz8l7va30br357";
  };

  buildInputs = [ curl libgcrypt ];

  preCheck =
    # Since `localhost' can't be resolved in a chroot, work around it.
    '' for i in "src/test"*"/"*.[ch]
       do
         sed -i "$i" -es/localhost/127.0.0.1/g
       done
    '';

  # Disabled because the tests can time-out.
  doCheck = false;

  meta = {
    description = "Embeddable HTTP server library";

    longDescription = ''
      GNU libmicrohttpd is a small C library that is supposed to make
      it easy to run an HTTP server as part of another application.
    '';

    license = stdenv.lib.licenses.lgpl2Plus;

    homepage = http://www.gnu.org/software/libmicrohttpd/;

    maintainers = [ ];
  };
}
