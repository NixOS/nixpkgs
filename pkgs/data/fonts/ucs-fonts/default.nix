{ stdenv, fetchurl, mkfontdir, mkfontscale }:

stdenv.mkDerivation rec {
  name = "ucs-fonts-${version}";
  version = "20090406";

  srcs = [
    (fetchurl {
      url = http://www.cl.cam.ac.uk/~mgk25/download/ucs-fonts.tar.gz;
      sha256 = "12hgizg25fzmk10wjl0c88x97h3pg5r9ga122s3y28wixz6x2bvh";
    })
    (fetchurl {
      url = http://www.cl.cam.ac.uk/~mgk25/download/ucs-fonts-asian.tar.gz;
      sha256 = "0ibjy4xpz5j373hsdr8bx99czfpclqmviwwv768j8n7z12z3wa51";
    })
    (fetchurl {
      url = http://www.cl.cam.ac.uk/~mgk25/download/ucs-fonts-75dpi100dpi.tar.gz;
      sha256 = "08vqr8yb636xa1s28vf3pm22dzkia0gisvsi2svqjqh4kk290pzh";
    })
  ];

  sourceRoot = ".";

  buildInputs = [ mkfontdir mkfontscale ];

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/fonts
    cp *.bdf $out/share/fonts
    cd $out/share/fonts
    mkfontdir
    mkfontscale
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "12fh3kbsib0baqwk6148fnzqrj9gs4vnl7yd5n9km72sic1z1xwk";

  meta = with stdenv.lib; {
    description = "Unicode bitmap fonts";
    maintainers = [ maintainers.raskin ];
    platforms = platforms.all;
  };
}
