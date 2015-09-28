{ stdenv, fetchFromGitHub, autoreconfHook, docbook_xsl, gtk_doc, icu
, libxslt, pkgconfig }:

let

  version = "${libVersion}-list-${listVersion}";

  listVersion = "2015-09-15";
  listSources = fetchFromGitHub {
    sha256 = "1rrds3bsnxb2n2ifl0zg6mh1h8nd3h1ba4bz0dznrrlqzfbav0l2";
    rev = "4f89204a24e99d8a65353cc62d5bc4dea1b2ae31";
    repo = "list";
    owner = "publicsuffix";
  };

  libVersion = "0.11.0";

in stdenv.mkDerivation {
  name = "libpsl-${version}";

  src = fetchFromGitHub {
    sha256 = "08k7prrr83lg6jmm5r5k4alpm2in4qlnx49ypb4bxv16lq8dcnmm";
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
    cp -Rv "${listSources}"/* list
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
