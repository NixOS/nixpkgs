{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, gettext
, gtk-doc, libxslt, docbook_xml_dtd_43, docbook_xsl
, python3, pcre2, gmp, mpfr
}:

let
  version = "2.1";
in stdenv.mkDerivation rec {
  name = "libbytesize-${version}";

  src = fetchFromGitHub {
    owner = "storaged-project";
    repo = "libbytesize";
    rev = version;
    sha256 = "0qb6zx2fdghm21lishlcrhnwf4wwy5p69dsgp0504kn93ii7mw3m";
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
