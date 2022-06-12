{ lib
, stdenv
, fetchurl
, guile
, texinfo
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "guile-json";
  version = "4.7.1";

  src = fetchurl {
    url = "mirror://savannah/guile-json/${pname}-${version}.tar.gz";
    sha256 = "sha256-xTSaI4D2fIphOps698mNITJdRDAjNp5vdhs2bpaUaEM=";
  };

  postConfigure = ''
    sed -i '/moddir\s*=/s%=.*%=''${out}/share/guile/site%' Makefile;
    sed -i '/objdir\s*=/s%=.*%=''${out}/share/guile/ccache%' Makefile;
    sed -i '/moddir\s*=/s%=.*%=''${out}/share/guile/site/json%' json/Makefile;
    sed -i '/objdir\s*=/s%=.*%=''${out}/share/guile/ccache/json%' json/Makefile;
  '';

  nativeBuildInputs = [
    pkg-config texinfo
  ];
  buildInputs = [
    guile
  ];

  meta = with lib; {
    description = "JSON Bindings for GNU Guile";
    homepage = "https://savannah.nongnu.org/projects/guile-json";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ethancedwards8 ];
    platforms = platforms.all;
  };
}
