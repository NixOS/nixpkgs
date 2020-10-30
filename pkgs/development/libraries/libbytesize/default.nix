{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, gettext
, gtk-doc, libxslt, docbook_xml_dtd_43, docbook_xsl
, python3, pcre2, gmp, mpfr
}:

let
  version = "2.4";
in stdenv.mkDerivation rec {
  pname = "libbytesize";
  inherit version;

  src = fetchFromGitHub {
    owner = "storaged-project";
    repo = "libbytesize";
    rev = version;
    sha256 = "1kq0hnw2yxjdmcrwvgp0x4j1arkka23k8vp2l6nqcw9lc15x18fp";
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
