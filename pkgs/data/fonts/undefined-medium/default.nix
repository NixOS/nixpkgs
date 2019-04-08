{ stdenv, fetchzip }:

fetchzip rec {
  name = "undefined-medium-1.0";

  url = https://github.com/andirueckel/undefined-medium/archive/v1.0.zip;

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile ${name}/fonts/otf/\*.otf -d $out/share/fonts/opentype
  '';

  sha256 = "0v3p1g9f1c0d6b9lhrvm1grzivm7ddk7dvn96zl5hdzr2y60y1rw";

  meta = with stdenv.lib; {
    homepage = https://undefined-medium.com/;
    description = "A pixel grid-based monospace typeface";
    longDescription = ''
      undefined medium is a free and open-source pixel grid-based
      monospace typeface suitable for programming, writing, and
      whatever else you can think of … it’s pretty undefined.
    '';
    license = licenses.ofl;
    maintainers = [ maintainers.rycee ];
    platforms = platforms.all;
  };
}
