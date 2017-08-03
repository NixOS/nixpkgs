{stdenv, fetchurl}:

# adapted from https://aur.archlinux.org/packages/tt/ttf-opensans/PKGBUILD

stdenv.mkDerivation rec {
  name = "opensans-ttf-20140617";

  src = fetchurl {
    url = "https://hexchain.org/pub/archlinux/ttf-opensans/opensans.tar.gz";
    sha256 = "1ycn39dijhd3lffmafminrnfmymdig2jvc6i47bb42fx777q97q4";
  };

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp *.ttf $out/share/fonts/truetype
  '';

  meta = {
    description = "Open Sans fonts";
    longDescription = ''
      Open Sans is a humanist sans serif typeface designed by Steve Matteson,
      Type Director of Ascender Corp.
    '';
    homepage = http://en.wikipedia.org/wiki/Open_Sans;
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ ];
  };
}
