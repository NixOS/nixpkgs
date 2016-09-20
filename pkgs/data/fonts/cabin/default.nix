{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "cabin-1.005";

  src = fetchFromGitHub {
    owner = "impallari";
    repo = "Cabin";
    rev = "982839c790e9dc57c343972aa34c51ed3b3677fd";
    sha256 = "16v7spviphvdh2rrr8klv11lc9hxphg12ddf0qs7xdx801ri0ppn";
  };

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    mkdir -p $out/share/doc/${name}
    cp -v "fonts/OTF/"*.otf $out/share/fonts/opentype/
    cp -v README.md FONTLOG.txt $out/share/doc/${name}
  '';

  meta = with stdenv.lib; {
    description = "A humanist sans with 4 weights and true italics";
    longDescription = ''
      The Cabin font family is a humanist sans with 4 weights and true italics,
      inspired by Edward Johnston’s and Eric Gill’s typefaces, with a touch of
      modernism. Cabin incorporates modern proportions, optical adjustments, and
      some elements of the geometric sans. It remains true to its roots, but has
      its own personality.

      The weight distribution is almost monotone, although top and bottom curves
      are slightly thin. Counters of the b, g, p and q are rounded and optically
      adjusted. The curved stem endings have a 10 degree angle. E and F have
      shorter center arms. M is splashed.
    '';
    homepage = http://www.impallari.com/cabin;
    license = licenses.ofl;
    maintainers = with maintainers; [ cmfwyp ];
    platforms = platforms.all;
  };
}
