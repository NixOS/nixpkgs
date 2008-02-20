args: with args;
stdenv.mkDerivation rec {
  name = "ortp-" + version;

  src = fetchurl {
    url = "mirror://savannah/linphone/ortp/sources/${name}.tar.gz";
    sha256 = "0gyl0yzfg78sjhbwnwc2g8yn4riwd1wcv183qihgan6z2d5cfbrg";
  };

  configureFlags = "--enable-shared --disable-static";

  meta = {
    description = "a Real-Time Transport Protocol (RFC3550) stack under LGPL";
    homepage = http://www.linphone.org/index.php/eng/code_review/ortp;
  };
}
