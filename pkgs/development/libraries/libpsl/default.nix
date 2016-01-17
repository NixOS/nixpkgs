{ stdenv, fetchFromGitHub, autoreconfHook, docbook_xsl, gtk_doc, icu
, libxslt, pkgconfig, python }:

let

  version = "${libVersion}-list-${listVersion}";

  listVersion = "2016-01-09";
  listSources = fetchFromGitHub {
    sha256 = "1xsal9vyan954ahyn9pxvqpipmpcf6drp30xz7ag5xp3f2clcx8s";
    rev = "0f7cc8b00498812ddaa983c56d67ef3713e48350";
    repo = "list";
    owner = "publicsuffix";
  };

  libVersion = "0.12.0";

in stdenv.mkDerivation {
  name = "libpsl-${version}";

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
    inherit version;
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
