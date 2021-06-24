{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, gettext
, gtk-doc, libxslt, docbook_xml_dtd_43, docbook_xsl
, python3, pcre2, gmp, mpfr
}:

let
  version = "2.5";
in stdenv.mkDerivation rec {
  pname = "libbytesize";
  inherit version;

  src = fetchFromGitHub {
    owner = "storaged-project";
    repo = "libbytesize";
    rev = version;
    sha256 = "sha256-F8Ur8gtNYp4PYfBQ9sDJGBgW7KohJYNEU9SI2SbNuvM=";
  };

  outputs = [ "out" "dev" "devdoc" ];

  nativeBuildInputs = [ autoreconfHook pkg-config gettext gtk-doc libxslt docbook_xml_dtd_43 docbook_xsl python3 ];

  buildInputs = [ pcre2 gmp mpfr ];

  meta = with lib; {
    description = "A tiny library providing a C “class” for working with arbitrary big sizes in bytes";
    homepage = src.meta.homepage;
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [];
    platforms = platforms.linux;
  };
}
