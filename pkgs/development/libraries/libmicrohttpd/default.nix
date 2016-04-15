{ lib, stdenv, fetchurl, libgcrypt }:

stdenv.mkDerivation rec {
  name = "libmicrohttpd-0.9.44";

  src = fetchurl {
    url = "mirror://gnu/libmicrohttpd/${name}.tar.gz";
    sha256 = "07j1p21rvbrrfpxngk8xswzkmjkh94bp1971xfjh1p0ja709qwzj";
  };

  outputs = [ "dev" "out" "docdev" ];

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
