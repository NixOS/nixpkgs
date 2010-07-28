{ stdenv, fetchurl, wrapFonts }:

let

  srcA = fetchurl {
    url = http://www.cl.cam.ac.uk/~mgk25/download/ucs-fonts.tar.gz;
    sha256 = "12hgizg25fzmk10wjl0c88x97h3pg5r9ga122s3y28wixz6x2bvh";
  };
  
  srcB = fetchurl {
    url = http://www.cl.cam.ac.uk/~mgk25/download/ucs-fonts-asian.tar.gz;
    sha256 = "0ibjy4xpz5j373hsdr8bx99czfpclqmviwwv768j8n7z12z3wa51";
  };
  
  srcC = fetchurl {
    url = http://www.cl.cam.ac.uk/~mgk25/download/ucs-fonts-75dpi100dpi.tar.gz;
    sha256 = "08vqr8yb636xa1s28vf3pm22dzkia0gisvsi2svqjqh4kk290pzh";
  };  

in

wrapFonts (stdenv.mkDerivation {
  name = "ucs-fonts";
  
  phases = ["installPhase"];
  
  installPhase = ''
    tar xf ${srcA}
    tar xf ${srcB}
    tar xf ${srcC}
    mkdir -p $out/share/fonts/ucs-fonts
    cp *.bdf $out/share/fonts/ucs-fonts
  '';

  meta = {
    description = "Unicode bitmap fonts";
  };
})
