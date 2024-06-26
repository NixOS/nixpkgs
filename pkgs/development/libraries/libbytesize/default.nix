{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  docbook_xml_dtd_43,
  docbook_xsl,
  gettext,
  gmp,
  gtk-doc,
  libxslt,
  mpfr,
  pcre2,
  pkg-config,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libbytesize";
  version = "2.10";

  src = fetchFromGitHub {
    owner = "storaged-project";
    repo = "libbytesize";
    rev = finalAttrs.version;
    hash = "sha256-IPBoYcnSQ1/ws3mzPUXxgbetZkXRWrGhtakXaVVFb6U=";
  };

  outputs = [
    "out"
    "dev"
    "devdoc"
    "man"
  ];

  nativeBuildInputs = [
    autoreconfHook
    docbook_xml_dtd_43
    docbook_xsl
    gettext
    gtk-doc
    libxslt
    pkg-config
    python3
  ];

  buildInputs = [
    gmp
    mpfr
    pcre2
  ];

  strictDeps = true;

  meta = {
    homepage = "https://github.com/storaged-project/libbytesize";
    description = "Tiny library providing a C 'class' for working with arbitrary big sizes in bytes";
    mainProgram = "bscalc";
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.linux;
  };
})
