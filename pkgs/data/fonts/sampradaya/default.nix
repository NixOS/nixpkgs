{ lib, mkFont, fetchurl }:

mkFont {
  pname = "sampradaya";
  version = "0.1.0";

  src = fetchurl {
    url = "https://github.com/deepestblue/Sampradaya/releases/download/v0.1.0/Sampradaya-osx.ttf";
    sha256 = "1l8asiqbc6q0xcmjypw7z2gl9w32pnar46dh6lap38nqr1aykh07";
  };

  noUnpackFonts = true;

  meta = with lib; {
    homepage = "https://bitbucket.org/OorNaattaan/sampradaya/";
    description = "Unicode-compliant Grantha font";
    maintainers = with maintainers; [ mathnerd314 ];
    license = licenses.ofl; # See font metadata
    platforms = platforms.all;
  };
}
