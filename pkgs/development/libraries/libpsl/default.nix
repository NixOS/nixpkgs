{ stdenv, fetchFromGitHub, autoreconfHook, docbook_xsl, gtk_doc, icu
, libxslt, pkgconfig }:

let

  version = "${libVersion}-list-${listVersion}";

  listVersion = "2015-08-27";
  listSources = fetchFromGitHub {
    sha256 = "14kgxyfvvrwqyxmfy1by1pzbbv6hs9n744v8zr160rz8rln8lzb9";
    rev = "1fc1ed365818a6a77d6f31d425ff03ca54cdc7f3";
    repo = "list";
    owner = "publicsuffix";
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
