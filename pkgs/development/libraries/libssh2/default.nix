{stdenv, fetchurlBoot, openssl, zlib}:

stdenv.mkDerivation rec {
  name = "libssh2-1.5.0";

  src = fetchurlBoot {
    url = "${meta.homepage}/download/${name}.tar.gz";
    sha256 = "1z6hfgak00yz0azx6lk6n688mywhdxx03j6sdf95p3w6ssnnn6c3";
  };

  buildInputs = [ openssl zlib ];

  meta = {
    description = "A client-side C library implementing the SSH2 protocol";
    homepage = http://www.libssh2.org;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
