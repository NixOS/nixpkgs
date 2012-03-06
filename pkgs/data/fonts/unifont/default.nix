{ stdenv, fetchurl, mkfontscale, mkfontdir, bdftopcf, fontutil }:

let

  ttf = fetchurl {
    url = http://unifoundry.com/unifont-5.1.20080907.ttf.gz;
    sha256 = "03ssxsfhnayarzx15mn6khry2kgdxhkkc1bqzgr0c85ab5xm9jxw";
  };

  pcf = fetchurl {
    url = http://unifoundry.com/unifont-5.1.20080820.pcf.gz;
    sha256 = "0qwsgaplb2a79w14rrvazby3kwx7vyk08x70n0ih5dr91x3rqaqj";
  };

in

stdenv.mkDerivation {
  name = "unifont-5.1-20080907";

  buildInputs = [ mkfontscale mkfontdir bdftopcf fontutil ];

  unpackPhase = "true";
  
  installPhase =
    ''
      mkdir -p $out/share/fonts $out/share/fonts/truetype
      cp ${pcf} $out/share/fonts/unifont.pcf.gz
      gunzip < ${ttf} > $out/share/fonts/truetype/unifont.ttf
      cd $out/share/fonts
      mkfontdir 
      mkfontscale
    '';
    
  meta = {
    description = "Unicode font for Base Multilingual Plane.";
  };
}
