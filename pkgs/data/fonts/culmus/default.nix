{ stdenv, fetchzip }:

let
  version = "0.133";
in fetchzip {
  name = "culmus-${version}-1";

  url = "mirror://sourceforge/culmus/culmus/${version}/culmus-${version}.tar.gz";

  postFetch = ''
    tar -xzvf $downloadedFile --strip-components=1
    mkdir -p $out/share/fonts/{truetype,type1}
    cp -v *.pfa $out/share/fonts/type1/
    cp -v *.afm $out/share/fonts/type1/
    cp -v fonts.scale-type1 $out/share/fonts/type1/fonts.scale
    cp -v *.ttf $out/share/fonts/truetype/
    cp -v *.otf $out/share/fonts/truetype/
    cp -v fonts.scale-ttf $out/share/fonts/truetype/fonts.scale
    mkdir -p $out/etc/fonts/conf.d
    cp -v culmus.conf $out/etc/fonts/conf.d/39-culmus.conf
  '';

  sha256 = "1lvwv15lpk4cqarh2ncl83c43fmqxnzqaqzfm251zkx6svi1l0is";

  meta = {
    description = "Culmus Hebrew fonts";
    longDescription = "The Culmus project aims at providing the Hebrew-speaking GNU/Linux and Unix community with a basic collection of Hebrew fonts for X Windows.";
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.gpl2;
    homepage = http://culmus.sourceforge.net/;
    downloadPage = http://culmus.sourceforge.net/download.html;
  };
}
