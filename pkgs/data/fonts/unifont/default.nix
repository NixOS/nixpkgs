args: with args; with debPackage;
debBuild ({
  src = fetchurl {
    url = mirror://debian/pool/main/u/unifont/unifont_5.1.20080914.orig.tar.gz;
    sha256 = "1p8f3dkg0zy9f5hwn1q728hps258ll84xg9a7xqbhj2csvnsyajd";
  };
  patch = fetchurl {
    url = mirror://debian/pool/main/u/unifont/unifont_5.1.20080914-1.diff.gz;
    sha256 = "0faicwbjlgy78zrc94ffg52f71msll8kxc43bks40z8qb02nr7qx";
  };
  name = "unifont-5.1-20080914";
  buildInputs = [mkfontscale mkfontdir bdftopcf fontutil perl];
  meta = {
    description = "Unicode font for Base Multilingual Plane.";
  };
  #extraReplacements = ''sed -e s@/usr/bin/perl@${perl}/bin/perl@ -i hex2bdf.unsplit'';
  omitConfigure = true;
  Install = ''
    ensureDir $out/share/fonts $out/share/fonts/truetype
    cd font/precompiled
    cp unifont.pcf.gz $out/share/fonts
    cp unifont.ttf $out/share/fonts/truetype 
    cd $out/share/fonts
    mkfontdir 
    mkfontscale
  '';
  extraInstallDeps = ["defEnsureDir"];
} // args)
