{ stdenv, fetchzip }:

fetchzip rec {
  name = "cabin-1.005";

  url = https://github.com/impallari/Cabin/archive/982839c790e9dc57c343972aa34c51ed3b3677fd.zip;

  postFetch = ''
    mkdir -p $out/share/{doc,fonts}
    unzip -j $downloadedFile \*.otf                    -d $out/share/fonts/opentype
    unzip -j $downloadedFile \*README.md \*FONTLOG.txt -d "$out/share/doc/${name}"
  '';

  sha256 = "1ax5c2iab48qsk9zn3gjvqaib2lnlm25f1wr0aysf5ngw0y0jkrd";

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
