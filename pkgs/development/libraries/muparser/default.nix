{lib, stdenv, fetchurl, unzip, setfile}:

stdenv.mkDerivation rec {
  pname = "muparser";
  version = "2.2.3";
  url-version = lib.replaceStrings ["."] ["_"] version;

  src = fetchurl {
    url = "mirror://sourceforge/muparser/muparser_v${url-version}.zip";
    sha256 = "00l92k231yb49wijzkspa2l58mapn6vh2dlxnlg0pawjjfv33s6z";
  };

  nativeBuildInputs = [ unzip ];
  buildInputs = lib.optionals stdenv.isDarwin [setfile];

  meta = {
    homepage = "http://muparser.sourceforge.net";
    description = "An extensible high performance math expression parser library written in C++";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
