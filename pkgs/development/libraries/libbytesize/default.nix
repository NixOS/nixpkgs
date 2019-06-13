{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, gettext
, gtk-doc, libxslt, docbook_xml_dtd_43, docbook_xsl
, python3, pcre2, gmp, mpfr
}:

let
  version = "2.0";
in stdenv.mkDerivation rec {
  name = "libbytesize-${version}";

  src = fetchFromGitHub {
    owner = "storaged-project";
    repo = "libbytesize";
    rev = version;
    sha256 = "0m950idlyv6mbkhr8ngnda5l5wwb5lzs4wn4kxl73cvdlcvklmwj";
  };

  outputs = [ "out" "dev" "devdoc" ];

  nativeBuildInputs = [ autoreconfHook pkgconfig gettext gtk-doc libxslt docbook_xml_dtd_43 docbook_xsl python3 ];

  buildInputs = [ pcre2 gmp mpfr ];

  meta = with stdenv.lib; {
    description = "A tiny library providing a C “class” for working with arbitrary big sizes in bytes";
    homepage = src.meta.homepage;
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [];
    platforms = platforms.linux;
  };
}
