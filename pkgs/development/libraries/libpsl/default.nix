{ stdenv, fetchFromGitHub, autoreconfHook, docbook_xsl, gtk-doc, icu
, libxslt, pkgconfig, python2 }:

let

  listVersion = "2017-02-03";
  listSources = fetchFromGitHub {
    sha256 = "0fhc86pjv50hxj3xf9r4mh0zzvdzqp5lac20caaxq1hlvdzavaa3";
    rev = "37e30d13801eaad3383b122c11d8091c7ac21040";
    repo = "list";
    owner = "publicsuffix";
  };

  libVersion = "0.17.0";

in stdenv.mkDerivation rec {
  name = "libpsl-${version}";
  version = "${libVersion}-list-${listVersion}";

  src = fetchFromGitHub {
    sha256 = "08dbl6ihnlf0kj4c9pdpjv9mmw7p676pzh1q184wl32csra5pzdd";
    rev = "libpsl-${libVersion}";
    repo = "libpsl";
    owner = "rockdaboot";
  };

  buildInputs = [ icu libxslt ];
  nativeBuildInputs = [ autoreconfHook docbook_xsl gtk-doc pkgconfig python2 ];

  postPatch = ''
    substituteInPlace src/psl.c --replace bits/stat.h sys/stat.h
    patchShebangs src/psl-make-dafsa
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
  };
}
