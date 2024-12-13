{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  gtk2,
  libxml2,
  libxslt,
  pango,
  perl,
  pkg-config,
  popt,
}:

stdenv.mkDerivation rec {
  pname = "xmlroff";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "0dgp72094lx9i9gvg21pp8ak7bg39707rdf6wz011p9s6n6lrq5g";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    libxml2
    libxslt
    pango
    gtk2
    popt
  ];

  sourceRoot = "${src.name}/xmlroff";

  enableParallelBuilding = true;

  configureScript = "./autogen.sh";

  configureFlags = [
    "--disable-gp"
  ];

  preBuild = ''
    substituteInPlace tools/insert-file-as-string.pl --replace "/usr/bin/perl" "${perl}/bin/perl"
    substituteInPlace Makefile --replace "docs" ""  # docs target wants to download from network
  '';

  meta = with lib; {
    description = "XSL Formatter";
    homepage = "http://xmlroff.org/";
    platforms = platforms.unix;
    license = licenses.bsd3;
    mainProgram = "xmlroff";
  };
}
