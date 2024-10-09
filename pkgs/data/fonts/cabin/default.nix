{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "cabin";
  version = "1.005";

  src = fetchFromGitHub {
    owner = "impallari";
    repo = "Cabin";
    rev = "982839c790e9dc57c343972aa34c51ed3b3677fd";
    hash = "sha256-9l4QcwCot340Bq41ER68HSZGQ9h0opyzgG3DG/fVZ5s=";
  };

  installPhase = ''
    runHook preInstall

    install -m444 -Dt $out/share/fonts/opentype fonts/OTF/*.otf
    install -m444 -Dt $out/share/doc/${pname}-${version} README.md FONTLOG.txt

    runHook postInstall
  '';

  meta = with lib; {
    description = "Humanist sans with 4 weights and true italics";
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
    homepage = "http://www.impallari.com/cabin";
    license = licenses.ofl;
    maintainers = with maintainers; [ cmfwyp ];
    platforms = platforms.all;
  };
}
