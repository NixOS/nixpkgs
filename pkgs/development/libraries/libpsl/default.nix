{ stdenv, fetchFromGitHub, autoreconfHook, docbook_xsl, gtk_doc, icu
, libxslt, pkgconfig, python }:

let

  listVersion = "2016-02-25";
  listSources = fetchFromGitHub {
    sha256 = "0i9aa0bl3x50z0ba4n06pajpfncw8n780hhql13b1vppgfc6s4i7";
    rev = "84fd7e2a090f53ba4378f2a0e08cdaaa882ce3e5";
    repo = "list";
    owner = "publicsuffix";
  };

  libVersion = "0.12.0";

in stdenv.mkDerivation rec {
  name = "libpsl-${version}";
  version = "${libVersion}-list-${listVersion}";

  src = fetchFromGitHub {
    sha256 = "13w3lc752az2swymg408f3w2lbqs0f2h5ri6d5jw1vv9z0ij9xlw";
    rev = "libpsl-${libVersion}";
    repo = "libpsl";
    owner = "rockdaboot";
  };

  buildInputs = [ icu libxslt ];
  nativeBuildInputs = [ autoreconfHook docbook_xsl gtk_doc pkgconfig python ];

  postPatch = ''
    substituteInPlace src/psl.c --replace bits/stat.h sys/stat.h
    patchShebangs src/make_dafsa.py
  '';

  preAutoreconf = ''
    mkdir m4
    gtkdocize
  '';

  preConfigure = ''
    # The libpsl check phase requires the list's test scripts (tests/) as well
    cp -Rv "${listSources}"/* list
  '';
  configureFlags = [
    "--disable-builtin"
    "--disable-static"
    "--enable-gtk-doc"
    "--enable-man"
  ];

  enableParallelBuilding = true;

  doCheck = true;

  meta = with stdenv.lib; {
    description = "C library for the Publix Suffix List";
    longDescription = ''
      libpsl is a C library for the Publix Suffix List (PSL). A "public suffix"
      is a domain name under which Internet users can directly register own
      names. Browsers and other web clients can use it to avoid privacy-leaking
      "supercookies" and "super domain" certificates, for highlighting parts of
      the domain in a user interface or sorting domain lists by site.
    '';
    homepage = http://rockdaboot.github.io/libpsl/;
    license = licenses.mit;
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ nckx ];
  };
}
