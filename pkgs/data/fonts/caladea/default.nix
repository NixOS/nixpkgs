{ lib, fetchzip }:

let
  version = "20130214";
in fetchzip rec {
  name = "caladea-${version}";

  url = "https://commondatastorage.googleapis.com/chromeos-localmirror/distfiles/crosextrafonts-${version}.tar.gz";
  postFetch = ''
    tar -xzvf $downloadedFile --strip-components=1
    mkdir -p $out/etc/fonts/conf.d
    mkdir -p $out/share/fonts/truetype
    cp -v *.ttf $out/share/fonts/truetype
    cp -v ${./cambria-alias.conf} $out/etc/fonts/conf.d/30-cambria.conf
  '';
  sha256 = "0kwm42ggr8kvcn3554cpmv90xzam1sdncx7x3zs3bzp88mxrnv1z";

  meta = with lib; {
    # This font doesn't appear to have any official web site but this
    # one provides some good information and samples.
    homepage = http://openfontlibrary.org/en/font/caladea;
    description = "A serif font metric-compatible with Microsoft Cambria";
    longDescription = ''
      Caladea is a free font that is metric-compatible with the
      Microsoft Cambria font. Developed by Carolina Giovagnoli and
      Andrés Torresi at Huerta Tipográfica foundry.
    '';
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = [maintainers.rycee];

    # Reduce the priority of this package. The intent is that if you
    # also install the `vista-fonts` package, then you probably will
    # not want to install the font alias of this package.
    priority = 10;
  };
}
