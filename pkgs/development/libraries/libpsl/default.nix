{ stdenv, fetchFromGitHub, autoreconfHook, docbook_xsl, gtk_doc, icu
, libxslt, pkgconfig }:

let

  version = "${libVersion}-list-${listVersion}";

  listVersion = "2015-09-25";
  listSources = fetchFromGitHub {
    sha256 = "045snl0pz8ma5rk51xxbjcamm28hi4z2v7gd8zkkv8yrjyg9yp82";
    rev = "509db00ef21795e58bfc2c576cebf72c8ee7a6f9";
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

  postPatch = ''
    substituteInPlace src/psl.c --replace bits/stat.h sys/stat.h
  '';

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
