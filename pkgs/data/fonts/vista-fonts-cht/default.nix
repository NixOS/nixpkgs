{ lib, fetchzip, buildPackages }:

let
  pname = "vista-fonts-cht";
  version = "1";
in
fetchzip {
  name = "${pname}-${version}";

  url = https://download.microsoft.com/download/7/6/b/76bd7a77-be02-47f3-8472-fa1de7eda62f/VistaFont_CHT.EXE;

  postFetch = ''
    ${buildPackages.cabextract}/bin/cabextract --lowercase --filter '*.TTF' $downloadedFile

    mkdir -p $out/share/fonts/truetype
    cp *.ttf $out/share/fonts/truetype

    # Set up no-op font configs to override any aliases set up by
    # other packages.
    mkdir -p $out/etc/fonts/conf.d
    substitute ${./no-op.conf} $out/etc/fonts/conf.d/30-msjhenghei.conf \
      --subst-var-by fontname "Microsoft JhengHei"
  '';

  sha256 = "00v5h8gjm6pby8lbvm03sn29302am91vx93gyv8i72id63mbmy2j";

  meta = with lib; {
    description = "TrueType fonts from Microsoft Windows Vista For Traditional Chinese (Microsoft JhengHei)";
    homepage = https://www.microsoft.com/typography/fonts/family.aspx;
    license = licenses.unfree;
    maintainers = [ maintainers.atkinschang ];

    # Set a non-zero priority to allow easy overriding of the
    # fontconfig configuration files.
    priority = 5;
    platforms = platforms.all;
  };
}
