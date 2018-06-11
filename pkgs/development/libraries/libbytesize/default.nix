{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, gettext
, gtk-doc, libxslt, docbook_xml_dtd_43, docbook_xsl
, python3, pcre, gmp, mpfr
}:

let
  version = "1.3";
in stdenv.mkDerivation rec {
  name = "libbytesize-${version}";

  src = fetchFromGitHub {
    owner = "storaged-project";
    repo = "libbytesize";
    rev = version;
    sha256 = "1ys5d8rya8x4q34gn1hr96z7797s9gdzah0y0d7g84x5x6k50p30";
  };

  outputs = [ "out" "dev" "devdoc" ];

  nativeBuildInputs = [ autoreconfHook pkgconfig gettext gtk-doc libxslt docbook_xml_dtd_43 docbook_xsl python3 ];

  buildInputs = [ pcre gmp mpfr ];

  meta = with stdenv.lib; {
    description = "A tiny library providing a C “class” for working with arbitrary big sizes in bytes";
    homepage = src.meta.homepage;
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [];
    platforms = platforms.linux;
  };
}
