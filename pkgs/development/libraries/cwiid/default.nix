{ stdenv, autoreconfHook, fetchgit, bison, flex, bluez, pkgconfig, gtk }:

stdenv.mkDerivation rec {
  name = "cwiid-2010-02-21-git";

  src = fetchgit {
    url = https://github.com/abstrakraft/cwiid;
    sha256 = "6f5355d036dab017da713c49d3042011fa24fb732ed0d5ee338ab6f5ff400f06";
    rev = "fadf11e89b579bcc0336a0692ac15c93785f3f82";
  };

  hardeningDisable = [ "format" ];

  configureFlags = "--without-python";

  prePatch = ''
    sed -i -e '/$(LDCONFIG)/d' common/include/lib.mak.in
  '';

  buildInputs = [ autoreconfHook bison flex bluez pkgconfig gtk ];

  postInstall = ''
    # Some programs (for example, cabal-install) have problems with the double 0
    sed -i -e "s/0.6.00/0.6.0/" $out/lib/pkgconfig/cwiid.pc
  '';

  meta = {
    description = "Linux Nintendo Wiimote interface";
    homepage = http://cwiid.org;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.bennofs ];
    platforms = stdenv.lib.platforms.linux;
  };
}
