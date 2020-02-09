{ stdenv, fetchurl, autoreconfHook, pkgconfig, guile }:
stdenv.mkDerivation rec {
  pname = "guile-json";
  version = "3.3.0";

  src = fetchurl {
    url = "mirror://savannah/${pname}/${pname}-${version}.tar.gz";
    sha256 = "0gbqiii8yl5vg5d2gf8j6pd1wwy9c37sxpdvv94rqnnp11rkbdyf";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ guile ];

  meta = with stdenv.lib; {
    description = "JSON module for Guile";
    longDescription = ''
      - Strictly complies to http://json.org specification.
      - Build JSON documents programmatically via macros.
      - Unicode support for strings.
      - Allows JSON pretty printing.
    '';
    homepage = "https://savannah.nongnu.org/projects/guile-json/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ johnazoidberg ];
    platforms = platforms.unix;
  };
}
