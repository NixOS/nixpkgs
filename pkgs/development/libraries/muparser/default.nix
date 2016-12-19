{stdenv, fetchurl, unzip}:

stdenv.mkDerivation rec {
  name = "muparser-${version}";
  version = "2.2.3";
  url-version = stdenv.lib.replaceChars ["."] ["_"] version;

  src = fetchurl {
    url = "mirror://sourceforge/muparser/muparser_v${url-version}.zip";
    sha256 = "00l92k231yb49wijzkspa2l58mapn6vh2dlxnlg0pawjjfv33s6z";
  };

  buildInputs = [ unzip ];

  meta = {
    homepage = http://muparser.sourceforge.net;
    description = "An extensible high performance math expression parser library written in C++";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.linux;
  };
}
