{ stdenv, fetchFromGitHub, autoreconfHook, docbook_xsl, gtk_doc, icu
, libxslt, pkgconfig, python }:

let

  listVersion = "2016-05-23";
  listSources = fetchFromGitHub {
    sha256 = "1sld9s9d9g3fnppyvvn5w0xw50g1gq43d7yyk9yb710268kh31jc";
    rev = "05f7a0a82e2fea5afb8ba3736db3c294db270849";
    repo = "list";
    owner = "publicsuffix";
  };

  libVersion = "0.13.0";

in stdenv.mkDerivation rec {
  name = "libpsl-${version}";
  version = "${libVersion}-list-${listVersion}";

  src = fetchFromGitHub {
    sha256 = "12inl984r2qks51wyrzgll83y7k79q2lbhyc545dpk19qnfvp7gz";
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
