{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, docbook_xml_dtd_43
, docbook_xsl
, gettext
, gmp
, gtk-doc
, libxslt
, mpfr
, pcre2
, pkg-config
, python3
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libbytesize";
  version = "2.8";

  src = fetchFromGitHub {
    owner = "storaged-project";
    repo = "libbytesize";
    rev = finalAttrs.version;
    hash = "sha256-/TVv/srhbotIkne0G77hgBF4j+74INqVUr8zlKsaoM0=";
  };

  outputs = [ "out" "dev" "devdoc" "man" ];

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

  meta = {
    homepage = "https://github.com/storaged-project/libbytesize";
    description = "A tiny library providing a C 'class' for working with arbitrary big sizes in bytes";
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.linux;
  };
})
