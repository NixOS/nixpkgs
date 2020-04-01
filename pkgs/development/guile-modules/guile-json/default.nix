{ stdenv, fetchurl, guile, texinfo, pkg-config }:

stdenv.mkDerivation rec {
  pname = "guile-json";
  version = "3.3.0";

  src = fetchurl {
    url = "mirror://savannah/guile-json/${pname}-${version}.tar.gz";
    sha256 = "0gbqiii8yl5vg5d2gf8j6pd1wwy9c37sxpdvv94rqnnp11rkbdyf";
  };

  postConfigure = ''
    sed -i '/moddir\s*=/s%=.*%=''${out}/share/guile/site%' Makefile;
    sed -i '/objdir\s*=/s%=.*%=''${out}/share/guile/ccache%' Makefile;
    sed -i '/moddir\s*=/s%=.*%=''${out}/share/guile/site/json%' json/Makefile;
    sed -i '/objdir\s*=/s%=.*%=''${out}/share/guile/ccache/json%' json/Makefile;
  '';

  nativeBuildInputs = [ pkg-config texinfo ];
  buildInputs = [ guile ];

  meta = with stdenv.lib; {
    description = "JSON Bindings for GNU Guile";
    homepage = "https://savannah.nongnu.org/projects/guile-json";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ bqv ];
    platforms = platforms.all;
  };
}

