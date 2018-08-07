{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, gettext
, gtk-doc, libxslt, docbook_xml_dtd_43, docbook_xsl
, python2Packages, python3, pcre, gmp, mpfr
}:

stdenv.mkDerivation rec {
  name = "libbytesize-${version}";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "storaged-project";
    repo = "libbytesize";
    rev = version;
    sha256 = "1ys5d8rya8x4q34gn1hr96z7797s9gdzah0y0d7g84x5x6k50p30";
  };

  outputs = [ "out" "dev" "devdoc" ];

  nativeBuildInputs = [ autoreconfHook pkgconfig gettext gtk-doc libxslt docbook_xml_dtd_43 docbook_xsl python3 ];

  buildInputs = [ pcre gmp mpfr ];

  # canary_tests.sh needs systemd =/ and some python modules not packaged in nixpkgs
  postPatch = ''
    sed -i 's/canary_tests.sh//g' tests/Makefile.am
  '';

  postConfigure = ''
    patchShebangs tests
  '';

  checkInputs = with python2Packages; [ python six ];

  meta = with stdenv.lib; {
    description = "A tiny library providing a C “class” for working with arbitrary big sizes in bytes";
    homepage = src.meta.homepage;
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [];
    platforms = platforms.linux;
  };
}
