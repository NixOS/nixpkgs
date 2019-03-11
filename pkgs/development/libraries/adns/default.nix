{ stdenv, fetchurl }:

let
  version = "1.5.1";
in
stdenv.mkDerivation {
  name = "adns-${version}";

  src = fetchurl {
    urls = [
      "https://www.chiark.greenend.org.uk/~ian/adns/ftp/adns-${version}.tar.gz"
      "ftp://ftp.chiark.greenend.org.uk/users/ian/adns/adns-${version}.tar.gz"
      "mirror://gnu/adns/adns-${version}.tar.gz"
    ];
    sha256 = "1ssfh94ck6kn98nf2yy6743srpgqgd167va5ja3bwx42igqjc42v";
  };

  preConfigure =
    stdenv.lib.optionalString stdenv.isDarwin "sed -i -e 's|-Wl,-soname=$(SHLIBSONAME)||' configure";

  # https://www.mail-archive.com/nix-dev@cs.uu.nl/msg01347.html for details.
  doCheck = false;

  postInstall = stdenv.lib.optionalString stdenv.isDarwin ''
    install_name_tool -id $out/lib/libadns.so.1.5 $out/lib/libadns.so.1.5
  '';

  meta = {
    homepage = http://www.chiark.greenend.org.uk/~ian/adns/;
    description = "Asynchronous DNS Resolver Library";
    license = stdenv.lib.licenses.lgpl2;

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.peti ];
  };
}
