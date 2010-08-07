{stdenv, fetchurlBoot, openssl, zlib}:

stdenv.mkDerivation rec {
  name = "libssh2-1.2.6";

  src = fetchurlBoot {
    url = "${meta.homepage}/download/${name}.tar.gz";
    sha256 = "00f6hw972v7jd0rrdr6kx5cn7pa1spyx8xgc7vhjydksgsig3f8b";
  };

  buildInputs = [ openssl zlib ];

  meta = {
    description = "A client-side C library implementing the SSH2 protocol";
    homepage = http://www.libssh2.org;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
