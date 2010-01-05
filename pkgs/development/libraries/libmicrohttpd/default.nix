{stdenv, fetchurl, curl}:

stdenv.mkDerivation rec {
  name = "libmicrohttpd-0.4.4";

  src = fetchurl {
    url = "mirror://gnu/libmicrohttpd/${name}.tar.gz";
    sha256 = "1w486b4hpwnzpc4zdywm3f1q5zs7j4yh7xibbsig6b8cv1npn0rz";
  };

  buildInputs = [ curl ];

  preCheck =
    # Since `localhost' can't be resolved in a chroot, work around it.
    '' for i in "src/test"*"/"*.[ch]
       do
         sed -i "$i" -es/localhost/127.0.0.1/g
       done
    '';

  doCheck = true;

  meta = {
    description = "GNU libmicrohttpd, an embeddable HTTP server library";

    longDescription = ''
      GNU libmicrohttpd is a small C library that is supposed to make
      it easy to run an HTTP server as part of another application.
    '';

    license = "LGPLv2+";

    homepage = http://www.gnu.org/software/libmicrohttpd/;

    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
