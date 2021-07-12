{ lib
, stdenv
, fetchurl
, guile
, pkg-config
, texinfo
}:

stdenv.mkDerivation rec {
  pname = "guile-xcb";
  version = "1.3";

  src = fetchurl {
    url = "http://www.markwitmer.com/dist/${pname}-${version}.tar.gz";
    hash = "sha256-iYR6AYSTgUsURAEJTWcdHlc0f8LzEftAIsfonBteuxE=";
  };

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    guile
    texinfo
  ];

  configureFlags = [
    "--with-guile-site-dir=$out/share/guile/site"
    "--with-guile-site-ccache-dir=$out/share/guile/site"
  ];

  meta = with lib; {
    homepage = "http://www.markwitmer.com/guile-xcb/guile-xcb.html";
    description = "XCB bindings for Guile";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ vyp ];
    platforms = platforms.linux;
  };
}
