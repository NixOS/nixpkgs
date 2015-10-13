{ lib, stdenv, fetchurl, libgcrypt }:

stdenv.mkDerivation rec {
  name = "libmicrohttpd-0.9.43";

  src = fetchurl {
    url = "mirror://gnu/libmicrohttpd/${name}.tar.gz";
    sha256 = "17q6v5q0jpg57vylby6rx1qkil72bdx8gij1g9m694gxf5sb6js1";
  };

  outputs = [ "dev" "out" "doc" ]; # dev-doc only, I think

  buildInputs = [ libgcrypt ];

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

    license = lib.licenses.lgpl2Plus;

    homepage = http://www.gnu.org/software/libmicrohttpd/;

    maintainers = [ lib.maintainers.eelco ];
  };
}
