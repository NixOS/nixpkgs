{ lib, stdenv, fetchurl, cabextract }:

let
  fonts = [
    { name = "andale";  sha256 = "0w7927hlwayqf3vvanf8f3qp2g1i404jzqvhp1z3mp0sjm1gw905"; }
    { name = "arial";   sha256 = "1xkqyivbyb3z9dcalzidf8m4npzfpls2g0kldyn8g73f2i6plac5"; }
    { name = "arialb";  sha256 = "1a60zqrg63kjnykh5hz7dbpzvx7lyivn3vbrp7jyv9d1nvzz09d4"; }
    { name = "comic";   sha256 = "0ki0rljjc1pxkbsxg515fwx15yc95bdyaksa3pjd89nyxzzg6vcw"; }
    { name = "courie";  sha256 = "111k3waxki9yyxpjwl2qrdkswvsd2dmvhbjmmrwyipam2s31sldv"; }
    { name = "georgi";  sha256 = "0083jcpd837j2c06kp1q8glfjn9k7z6vg3wi137savk0lv6psb1c"; }
    { name = "impact";  sha256 = "1yyc5z7zmm3s418hmrkmc8znc55afsrz5dgxblpn9n81fhxyyqb0"; }
    { name = "times";   sha256 = "1aq7z3l46vwgqljvq9zfgkii6aivy00z1529qbjkspggqrg5jmnv"; }
    { name = "trebuc";  sha256 = "1jfsgz80pvyqvpfpaiz5pd8zwlcn67rg2jgynjwf22sip2dhssas"; }
    { name = "webdin";  sha256 = "0nnp2znmnmx87ijq9zma0vl0hd46npx38p0cc6lgp00hpid5nnb4"; }
    { name = "verdan";  sha256 = "15mdbbfqbyp25a6ynik3rck3m3mg44plwrj79rwncc9nbqjn3jy1"; }
    { name = "wd97vwr"; sha256 = "1lmkh3zb6xv47k0z2mcwk3vk8jff9m845c9igxm14bbvs6k2c4gn"; }
  ];

  eula = fetchurl {
    url = "http://corefonts.sourceforge.net/eula.htm";
    sha256 = "1aqbcnl032g2hd7iy56cs022g47scb0jxxp3mm206x1yqc90vs1c";
  };
in
stdenv.mkDerivation {
  pname = "corefonts";
  version = "1";

  exes = map ({name, sha256}: fetchurl {
    url = "mirror://sourceforge/corefonts/${name}32.exe";
    inherit sha256;
  }) fonts;

  nativeBuildInputs = [ cabextract ];

  buildCommand = ''
    for i in $exes; do
      cabextract --lowercase $i
    done
    cabextract --lowercase viewer1.cab

    # rename to more standard names
    mv andalemo.ttf  Andale_Mono.ttf
    mv ariblk.ttf    Arial_Black.ttf
    mv arial.ttf     Arial.ttf
    mv arialbd.ttf   Arial_Bold.ttf
    mv arialbi.ttf   Arial_Bold_Italic.ttf
    mv ariali.ttf    Arial_Italic.ttf
    mv comic.ttf     Comic_Sans_MS.ttf
    mv comicbd.ttf   Comic_Sans_MS_Bold.ttf
    mv cour.ttf      Courier_New.ttf
    mv courbd.ttf    Courier_New_Bold.ttf
    mv couri.ttf     Courier_New_Italic.ttf
    mv courbi.ttf    Courier_New_Bold_Italic.ttf
    mv georgia.ttf   Georgia.ttf
    mv georgiab.ttf  Georgia_Bold.ttf
    mv georgiai.ttf  Georgia_Italic.ttf
    mv georgiaz.ttf  Georgia_Bold_Italic.ttf
    mv impact.ttf    Impact.ttf
    mv tahoma.ttf    Tahoma.ttf
    mv times.ttf     Times_New_Roman.ttf
    mv timesbd.ttf   Times_New_Roman_Bold.ttf
    mv timesbi.ttf   Times_New_Roman_Bold_Italic.ttf
    mv timesi.ttf    Times_New_Roman_Italic.ttf
    mv trebuc.ttf    Trebuchet_MS.ttf
    mv trebucbd.ttf  Trebuchet_MS_Bold.ttf
    mv trebucit.ttf  Trebuchet_MS_Italic.ttf
    mv trebucbi.ttf  Trebuchet_MS_Italic.ttf
    mv verdana.ttf   Verdana.ttf
    mv verdanab.ttf  Verdana_Bold.ttf
    mv verdanai.ttf  Verdana_Italic.ttf
    mv verdanaz.ttf  Verdana_Bold_Italic.ttf
    mv webdings.ttf  Webdings.ttf

    install -m444 -Dt $out/share/fonts/truetype *.ttf

    # Also put the EULA there to be on the safe side.
    cp ${eula} $out/share/fonts/truetype/eula.html

    # Set up no-op font configs to override any aliases set up by other packages.
    mkdir -p $out/etc/fonts/conf.d
    for name in Andale-Mono Arial-Black Arial Comic-Sans-MS \
                Courier-New Georgia Impact Times-New-Roman \
                Trebuchet Verdana Webdings ; do
      substitute ${./no-op.conf} $out/etc/fonts/conf.d/30-''${name,,}.conf \
        --subst-var-by fontname "''${name//-/ }"
    done
  '';

  meta = with lib; {
    homepage = "http://corefonts.sourceforge.net/";
    description = "Microsoft's TrueType core fonts for the Web";
    platforms = platforms.all;
    license = licenses.unfreeRedistributable;
    # Set a non-zero priority to allow easy overriding of the
    # fontconfig configuration files.
    priority = 5;
  };
}
