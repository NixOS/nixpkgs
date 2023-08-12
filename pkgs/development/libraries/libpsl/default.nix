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
, valgrind
, publicsuffix-list
}:

let
  enableValgrindTests = !stdenv.isDarwin && lib.meta.availableOn stdenv.hostPlatform valgrind
    # Apparently valgrind doesn't support some new ARM features on (some) Hydra machines:
    #  VEX: Mismatch detected between RDMA and atomics features.
    && !stdenv.isAarch64
    # Valgrind on musl does not hook malloc calls properly, resulting in errors `Invalid free() / delete / delete[] / realloc()`
    # https://bugs.kde.org/show_bug.cgi?id=435441
    && !stdenv.hostPlatform.isMusl
  ;
in stdenv.mkDerivation rec {
  pname = "libpsl";
  version = "0.21.2";

  src = fetchurl {
    url = "https://github.com/rockdaboot/libpsl/releases/download/${version}/libpsl-${version}.tar.lz";
    sha256 = "sha256-qj1wbEUnhtE0XglNriAc022B8Dz4HWNtXPwQ02WQfxc=";
  };

  nativeBuildInputs = [
    autoreconfHook
    docbook_xsl
    docbook_xml_dtd_43
    gtk-doc
    lzip
    pkg-config
    python3
    libxslt
  ] ++ lib.optionals enableValgrindTests [
    valgrind
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
    "--with-psl-distfile=${publicsuffix-list}/share/publicsuffix/public_suffix_list.dat"
    "--with-psl-file=${publicsuffix-list}/share/publicsuffix/public_suffix_list.dat"
    "--with-psl-testfile=${publicsuffix-list}/share/publicsuffix/test_psl.txt"
  ] ++ lib.optionals enableValgrindTests [
    "--enable-valgrind-tests"
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
    changelog = "https://raw.githubusercontent.com/rockdaboot/${pname}/${pname}-${version}/NEWS";
    license = licenses.mit;
    maintainers = [ maintainers.c0bw3b ];
    mainProgram = "psl";
    platforms = platforms.unix;
    pkgConfigModules = [ "libpsl" ];
  };
}
