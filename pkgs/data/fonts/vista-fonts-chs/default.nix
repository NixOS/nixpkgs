{ lib, fetchzip, buildPackages }:

# Modified from vista-fonts

fetchzip {
  name = "vista-fonts-chs-1";

  url = http://download.microsoft.com/download/d/6/e/d6e2ff26-5821-4f35-a18b-78c963b1535d/VistaFont_CHS.EXE;

  postFetch = ''
    ${buildPackages.cabextract}/bin/cabextract --lowercase --filter '*.TTF' $downloadedFile

    mkdir -p $out/share/fonts/truetype
    cp *.ttf $out/share/fonts/truetype

    # Set up no-op font configs to override any aliases set up by
    # other packages.
    mkdir -p $out/etc/fonts/conf.d
    substitute ${./no-op.conf} $out/etc/fonts/conf.d/30-msyahei.conf \
      --subst-var-by fontname "Microsoft YaHei"
  '';

  sha256 = "1zwrgck84k80gpg7493jdnxnv9ajxk5c7qndinnmqydnrw239zbw";

  meta = {
    description = "TrueType fonts from Microsoft Windows Vista For Simplified Chinese (Microsoft YaHei)";
    homepage = https://www.microsoft.com/typography/fonts/family.aspx?FID=350;
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.ChengCat ];

    # Set a non-zero priority to allow easy overriding of the
    # fontconfig configuration files.
    priority = 5;
    platforms = lib.platforms.all;
  };
}
