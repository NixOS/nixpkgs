{stdenv, fetchurl, cabextract}:

let

  fonts = [
    {name = "andale";  sha256 = "0w7927hlwayqf3vvanf8f3qp2g1i404jzqvhp1z3mp0sjm1gw905";}
    {name = "arial";   sha256 = "1xkqyivbyb3z9dcalzidf8m4npzfpls2g0kldyn8g73f2i6plac5";}
    {name = "arialb";  sha256 = "1a60zqrg63kjnykh5hz7dbpzvx7lyivn3vbrp7jyv9d1nvzz09d4";}
    {name = "comic";   sha256 = "0ki0rljjc1pxkbsxg515fwx15yc95bdyaksa3pjd89nyxzzg6vcw";}
    {name = "courie";  sha256 = "111k3waxki9yyxpjwl2qrdkswvsd2dmvhbjmmrwyipam2s31sldv";}
    {name = "georgi";  sha256 = "0083jcpd837j2c06kp1q8glfjn9k7z6vg3wi137savk0lv6psb1c";}
    {name = "impact";  sha256 = "1yyc5z7zmm3s418hmrkmc8znc55afsrz5dgxblpn9n81fhxyyqb0";}
    {name = "times";   sha256 = "1aq7z3l46vwgqljvq9zfgkii6aivy00z1529qbjkspggqrg5jmnv";}
    {name = "trebuc";  sha256 = "1jfsgz80pvyqvpfpaiz5pd8zwlcn67rg2jgynjwf22sip2dhssas";}
    {name = "webdin";  sha256 = "0nnp2znmnmx87ijq9zma0vl0hd46npx38p0cc6lgp00hpid5nnb4";}
    {name = "verdan";  sha256 = "15mdbbfqbyp25a6ynik3rck3m3mg44plwrj79rwncc9nbqjn3jy1";}
    {name = "wd97vwr"; sha256 = "1lmkh3zb6xv47k0z2mcwk3vk8jff9m845c9igxm14bbvs6k2c4gn";}
  ];

  eula = fetchurl {
    url = http://corefonts.sourceforge.net/eula.htm;
    sha256 = "1aqbcnl032g2hd7iy56cs022g47scb0jxxp3mm206x1yqc90vs1c";
  };

in

stdenv.mkDerivation {
  name = "corefonts-1";

  exes = map ({name, sha256}: fetchurl {
    url = "mirror://sourceforge/corefonts/${name}32.exe";
    inherit sha256;
  }) fonts;

  buildInputs = [cabextract];

  buildCommand = "
    for i in $exes; do
        cabextract --lowercase $i
    done

    cabextract --lowercase viewer1.cab
  
    fontDir=$out/share/fonts/truetype
    ensureDir $fontDir
    cp *.ttf $fontDir

    # Also put the EULA there to be on the safe side.
    cp ${eula} $fontDir/eula.html
  ";
}
