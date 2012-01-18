{ stdenv, fetchurl, mkfontdir, mkfontscale }:

stdenv.mkDerivation {
  name = "clearlyU-12-1.9";

  src = fetchurl {
    url = http://www.math.nmsu.edu/~mleisher/Software/cu/cu12-1.9.tgz;
    sha256 = "1xn14jbv3m1khy7ydvad9ydkn7yygdbhjy9wm1v000jzjwr3lv21";
  };
  
  buildInputs = [ mkfontdir mkfontscale ];

  installPhase =
    ''
      mkdir -p $out/share/fonts
      cp *.bdf $out/share/fonts
      cd $out/share/fonts
      mkfontdir 
      mkfontscale
    '';

  meta = {
    description = "A Unicode font";
  };
}
