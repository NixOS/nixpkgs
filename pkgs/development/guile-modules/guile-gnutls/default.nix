{ lib
, stdenv
, fetchurl
, gnutls
, guile
, libtool
, pkg-config
, texinfo
}:

stdenv.mkDerivation rec {
  pname = "guile-gnutls";
  version = "4.0.0";

  src = fetchurl {
    url = "mirror://gnu/gnutls/guile-gnutls-${version}.tar.gz";
    hash = "sha256-W0y5JgMgduw0a7XAvA0CMflo/g9WWRPMFpNLt5Ovsjk=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    gnutls
    guile
    libtool
    texinfo
  ];

  configureFlags = [
    "--with-guile-site-dir=${builtins.placeholder "out"}/${guile.siteDir}"
    "--with-guile-site-ccache-dir=${builtins.placeholder "out"}/${guile.siteCcacheDir}"
    "--with-guile-extension-dir=${builtins.placeholder "out"}/lib/guile/${guile.effectiveVersion}/extensions"
  ];

  meta = with lib; {
    homepage = "https://gitlab.com/gnutls/guile/";
    description = "Guile bindings for GnuTLS library";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ foo-dogsquared ];
    platforms = guile.meta.platforms;
  };
}
