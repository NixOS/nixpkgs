{stdenv, fetchurl, curl}:

stdenv.mkDerivation rec {
  name = "libmicrohttpd-0.3.1";

  src = fetchurl {
    url = "mirror://gnu/libmicrohttpd/${name}.tar.gz";
    sha256 = "1zv8a7lwypwbwzam5jvr35wvxb13chyh0ir18k82nzm9q5s3v3n3";
  };

  buildInputs = [ curl ];

  doCheck = true;

  meta = {
    description = "GNU libmicrohttpd, an embeddable HTTP server library";

    longDescription = ''
      GNU libmicrohttpd is a small C library that is supposed to make
      it easy to run an HTTP server as part of another application.
    '';

    license = "LGPLv2+";

    homepage = http://www.gnu.org/software/libmicrohttpd/;
  };
}
