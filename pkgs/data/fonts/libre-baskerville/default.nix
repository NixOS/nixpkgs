{ stdenv, fetchzip }:

fetchzip rec {
  name = "libre-baskerville-1.000";

  url = https://github.com/impallari/Libre-Baskerville/archive/2fba7c8e0a8f53f86efd3d81bc4c63674b0c613f.zip;

  postFetch = ''
    mkdir -p $out/share/{doc,fonts}
    unzip    -j $downloadedFile \*.ttf                    -d $out/share/fonts/truetype
    unzip -n -j $downloadedFile \*README.md \*FONTLOG.txt -d "$out/share/doc/${name}"
  '';

  sha256 = "0arlq89b3vmpw3n4wbllsdvqblhz6p09dm19z1cndicmcgk26w2a";

  meta = with stdenv.lib; {
    description = "A webfont family optimized for body text";
    longDescription = ''
      Libre Baskerville is a webfont family optimized for body text. It's Based
      on 1941 ATF Baskerville Specimens but it has a taller x-height, wider
      counters and less contrast that allow it to work on small sizes in any
      screen.
    '';
    homepage = http://www.impallari.com/projects/overview/libre-baskerville;
    license = licenses.ofl;
    maintainers = with maintainers; [ cmfwyp ];
    platforms = platforms.all;
  };
}
