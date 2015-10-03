{stdenv, fetchurlBoot, openssl, zlib}:

stdenv.mkDerivation rec {
  name = "libssh2-1.6.0";

  src = fetchurlBoot {
    url = "${meta.homepage}/download/${name}.tar.gz";
    sha256 = "05c2is69c50lyikkh29nk6zhghjk4i7hjx0zqfhq47aald1jj82s";
  };

  buildInputs = [ openssl zlib ];

  meta = {
    description = "A client-side C library implementing the SSH2 protocol";
    homepage = http://www.libssh2.org;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
