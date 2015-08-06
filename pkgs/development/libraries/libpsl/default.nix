{ stdenv, fetchurl, fetchFromGitHub, autoreconfHook, docbook_xsl, gtk_doc
, icu, libxslt, pkgconfig }:

let

  version = "${libVersion}-list-${listVersion}";

  listVersion = "2015-08-03";
  listArchive = let
    rev = "447962d71bf512fe41e828afc7fa66a1701c7c3c";
  in fetchurl {
    sha256 = "0gp0cb6p8yvyy5kvgdwg45ian9rb07bb0a9ibdj58g21l54mx3r2";
    url = "https://codeload.github.com/publicsuffix/list/tar.gz/${rev}";
  };

  libVersion = "0.8.0";

in stdenv.mkDerivation {
  name = "libpsl-${version}";

  src = fetchFromGitHub {
    sha256 = "0mjnj36igk6w3c0d4k2fqqg1kl6bpnxfrcgcgz1zdw33gfa5gdi7";
    rev = "libpsl-${libVersion}";
    repo = "libpsl";
    owner = "rockdaboot";
  };

  buildInputs = [ icu libxslt ];
  nativeBuildInputs = [ autoreconfHook docbook_xsl gtk_doc pkgconfig ];

  preAutoreconf = ''
    mkdir m4
    gtkdocize
  '';

  preConfigure = ''
    # The libpsl check phase requires the list's test scripts (tests/) as well
    tar --directory=list --strip-components=1 -xf "${listArchive}"
  '';
  configureFlags = "--disable-static --enable-gtk-doc --enable-man";

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
