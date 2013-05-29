{stdenv, fetchurlBoot, openssl, zlib}:

stdenv.mkDerivation rec {
  name = "libssh2-1.4.3";

  src = fetchurlBoot {
    url = "${meta.homepage}/download/${name}.tar.gz";
    sha256 = "eac6f85f9df9db2e6386906a6227eb2cd7b3245739561cad7d6dc1d5d021b96d";
  };

  buildInputs = [ openssl zlib ];

  meta = {
    description = "A client-side C library implementing the SSH2 protocol";
    homepage = http://www.libssh2.org;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
