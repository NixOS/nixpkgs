{ lib, stdenv
, fetchurl
, autoreconfHook
, docbook_xsl
, docbook_xml_dtd_43
, gtk-doc
, lzip
, libidn2
, libunistring
, libxslt
, pkg-config
, python3
, buildPackages
, publicsuffix-list
, enablePython3 ? python3.availableOn stdenv.hostPlatform
}:

stdenv.mkDerivation rec {
  pname = "libpsl";
  version = "0.21.5";

  src = fetchurl {
    url = "https://github.com/rockdaboot/libpsl/releases/download/${version}/libpsl-${version}.tar.lz";
    hash = "sha256-mp9qjG7bplDPnqVUdc0XLdKEhzFoBOnHMgLZdXLNOi0=";
  };

  outputs = [ "out" "dev" ]
    # bin/psl-make-dafsa brings a large runtime closure through python3
    ++ lib.optional enablePython3 "bin";

  nativeBuildInputs = [
    autoreconfHook
    docbook_xsl
    docbook_xml_dtd_43
    gtk-doc
    lzip
    pkg-config
    libxslt
  ];

  buildInputs = [
    libidn2
    libunistring
    libxslt
  ] ++ lib.optional enablePython3 python3;

  propagatedBuildInputs = [
    publicsuffix-list
  ];

  postPatch = lib.optionalString enablePython3 ''
    patchShebangs src/psl-make-dafsa
  '';

  preAutoreconf = ''
    gtkdocize
  '';

  configureFlags = [
    # "--enable-gtk-doc"
    "--enable-man"
    "--with-psl-distfile=${publicsuffix-list}/share/publicsuffix/public_suffix_list.dat"
    "--with-psl-file=${publicsuffix-list}/share/publicsuffix/public_suffix_list.dat"
    "--with-psl-testfile=${publicsuffix-list}/share/publicsuffix/test_psl.txt"
    "PYTHON=${lib.getExe buildPackages.python3}"
  ];

  enableParallelBuilding = true;

  doCheck = true;

  meta = with lib; {
    description = "C library for the Publix Suffix List";
    longDescription = ''
      libpsl is a C library for the Publix Suffix List (PSL). A "public suffix"
      is a domain name under which Internet users can directly register own
      names. Browsers and other web clients can use it to avoid privacy-leaking
      "supercookies" and "super domain" certificates, for highlighting parts of
      the domain in a user interface or sorting domain lists by site.
    '';
    homepage = "https://rockdaboot.github.io/libpsl/";
    changelog = "https://raw.githubusercontent.com/rockdaboot/libpsl/libpsl-${version}/NEWS";
    license = licenses.mit;
    maintainers = [ maintainers.c0bw3b ];
    mainProgram = "psl";
    platforms = platforms.unix ++ platforms.windows;
    pkgConfigModules = [ "libpsl" ];
  };
}
