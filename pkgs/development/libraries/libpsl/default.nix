{ stdenv
, fetchurl
, autoreconfHook
, docbook_xsl
, docbook_xml_dtd_43
, gtk-doc
, lzip
, libidn2
, libunistring
, libxslt
, pkgconfig
, python3
, valgrind
, publicsuffix-list
}:

stdenv.mkDerivation rec {
  pname = "libpsl";
  version = "0.21.0";

  src = fetchurl {
    url = "https://github.com/rockdaboot/${pname}/releases/download/${pname}-${version}/${pname}-${version}.tar.lz";
    sha256 = "183hadbira0d2zvv8272lspy31dgm9x26z35c61s5axcd5wd9g9i";
  };

  nativeBuildInputs = [
    autoreconfHook
    docbook_xsl
    docbook_xml_dtd_43
    gtk-doc
    lzip
    pkgconfig
    python3
    valgrind
    libxslt
  ];

  buildInputs = [
    libidn2
    libunistring
    libxslt
  ];

  propagatedBuildInputs = [
    publicsuffix-list
  ];

  postPatch = ''
    patchShebangs src/psl-make-dafsa
  '';

  preAutoreconf = ''
    gtkdocize
  '';

  configureFlags = [
    # "--enable-gtk-doc"
    "--enable-man"
    "--enable-valgrind-tests"
    "--with-psl-distfile=${publicsuffix-list}/share/publicsuffix/public_suffix_list.dat"
    "--with-psl-file=${publicsuffix-list}/share/publicsuffix/public_suffix_list.dat"
    "--with-psl-testfile=${publicsuffix-list}/share/publicsuffix/test_psl.txt"
  ];

  enableParallelBuilding = true;

  doCheck = !stdenv.isDarwin;

  meta = with stdenv.lib; {
    description = "C library for the Publix Suffix List";
    longDescription = ''
      libpsl is a C library for the Publix Suffix List (PSL). A "public suffix"
      is a domain name under which Internet users can directly register own
      names. Browsers and other web clients can use it to avoid privacy-leaking
      "supercookies" and "super domain" certificates, for highlighting parts of
      the domain in a user interface or sorting domain lists by site.
    '';
    homepage = "https://rockdaboot.github.io/libpsl/";
    changelog = "https://raw.githubusercontent.com/rockdaboot/${pname}/${pname}-${version}/NEWS";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.c0bw3b ];
  };
}
