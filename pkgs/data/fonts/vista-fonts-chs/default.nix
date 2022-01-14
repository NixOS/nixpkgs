{ lib, stdenvNoCC, fetchurl, cabextract }:

stdenvNoCC.mkDerivation {
  pname = "vista-fonts-chs";
  version = "1";

  src = fetchurl {
    url = "https://web.archive.org/web/20161221192937if_/http://download.microsoft.com/download/d/6/e/d6e2ff26-5821-4f35-a18b-78c963b1535d/VistaFont_CHS.EXE";
    # Alternative mirror:
    # http://www.eeo.cn/download/font/VistaFont_CHS.EXE
    sha256 = "1qwm30b8aq9piyqv07hv8b5bac9ms40rsdf8pwix5dyk8020i8xi";
  };

  nativeBuildInputs = [ cabextract ];

  unpackPhase = ''
    cabextract --lowercase --filter '*.TTF' $src
  '';

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp *.ttf $out/share/fonts/truetype

    # Set up no-op font configs to override any aliases set up by
    # other packages.
    mkdir -p $out/etc/fonts/conf.d
    substitute ${./no-op.conf} $out/etc/fonts/conf.d/30-msyahei.conf \
      --subst-var-by fontname "Microsoft YaHei"
  '';

  meta = {
    description = "TrueType fonts from Microsoft Windows Vista For Simplified Chinese (Microsoft YaHei)";
    homepage = "https://www.microsoft.com/typography/fonts/family.aspx?FID=350";
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.ChengCat ];

    # Set a non-zero priority to allow easy overriding of the
    # fontconfig configuration files.
    priority = 5;
    platforms = lib.platforms.all;
  };
}
