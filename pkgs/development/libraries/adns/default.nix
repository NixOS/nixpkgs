{ stdenv, fetchurl }:

let
  version = "1.4";
in
stdenv.mkDerivation {
  name = "adns-${version}";

  src = fetchurl {
    urls = [
      "http://www.chiark.greenend.org.uk/~ian/adns/ftp/adns-${version}.tar.gz"
      "ftp://ftp.chiark.greenend.org.uk/users/ian/adns/adns-${version}.tar.gz"
      "mirror://gnu/adns/adns-${version}.tar.gz"
    ];
    sha256 = "1zm99i9fd5gfijd144ajngn6x73563355im79sqdi98pj6ir4yvi";
  };

  preConfigure =
    stdenv.lib.optionalString stdenv.isDarwin "sed -i -e 's|-Wl,-soname=$(SHLIBSONAME)||' configure";

  # http://thread.gmane.org/gmane.linux.distributions.nixos/1328 for details.
  doCheck = false;

  meta = {
    homepage = "http://www.chiark.greenend.org.uk/~ian/adns/";
    description = "Asynchronous DNS Resolver Library";
    license = stdenv.lib.licenses.lgpl2;

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
