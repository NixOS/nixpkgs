{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "undefined-medium";
  version = "1.0";

  src = fetchzip rec {
    url = "https://github.com/andirueckel/undefined-medium/archive/v1.0.zip";
    sha256 = "1bkzvwpmz0rx5sra18sxqrdjazqpzh7hl8pa5lx34x3v6kp9avqw";
  };

  meta = with lib; {
    homepage = "https://undefined-medium.com/";
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
