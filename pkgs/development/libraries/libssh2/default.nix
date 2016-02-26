{stdenv, fetchurlBoot, openssl, zlib}:

stdenv.mkDerivation rec {
  name = "libssh2-1.7.0";

  src = fetchurlBoot {
    url = "${meta.homepage}/download/${name}.tar.gz";
    sha256 = "116mh112w48vv9k3f15ggp5kxw5sj4b88dzb5j69llsh7ba1ymp4";
  };

  buildInputs = [ openssl zlib ];

  meta = {
    description = "A client-side C library implementing the SSH2 protocol";
    homepage = http://www.libssh2.org;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
