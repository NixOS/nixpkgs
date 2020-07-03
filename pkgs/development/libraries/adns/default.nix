{ stdenv, fetchurl }:

let
  version = "1.5.2";
in
stdenv.mkDerivation {
  pname = "adns";
  inherit version;

  src = fetchurl {
    urls = [
      "https://www.chiark.greenend.org.uk/~ian/adns/ftp/adns-${version}.tar.gz"
      "ftp://ftp.chiark.greenend.org.uk/users/ian/adns/adns-${version}.tar.gz"
      "mirror://gnu/adns/adns-${version}.tar.gz"
    ];
    sha256 = "0z9ambw4pjnvwhn4bhxbrh20zpjsfj1ixm2lxa8x1x6w36g3ip6q";
  };

  preConfigure =
    stdenv.lib.optionalString stdenv.isDarwin "sed -i -e 's|-Wl,-soname=$(SHLIBSONAME)||' configure";

  # https://www.mail-archive.com/nix-dev@cs.uu.nl/msg01347.html for details.
  doCheck = false;

  postInstall = stdenv.lib.optionalString stdenv.isDarwin ''
    install_name_tool -id $out/lib/libadns.so.1.5 $out/lib/libadns.so.1.5
  '';

  meta = {
    homepage = "http://www.chiark.greenend.org.uk/~ian/adns/";
    description = "Asynchronous DNS Resolver Library";
    license = stdenv.lib.licenses.lgpl2;

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.peti ];
  };
}
