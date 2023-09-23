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
  version = "3.7.12";

  src = fetchurl {
    url = "mirror://gnu/gnutls/guile-gnutls-${version}.tar.gz";
    hash = "sha256-XTrxFXMJPeWfJYQVhy4sWxTMqd0lGosuwWQ9bpf+4zY=";
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
