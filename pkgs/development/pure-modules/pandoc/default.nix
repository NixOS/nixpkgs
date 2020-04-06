{ stdenv, fetchurl, pkgconfig, pure, pandoc, gawk, getopt }:

stdenv.mkDerivation rec {
  baseName = "pandoc";
  version = "0.1";
  name = "pure-${baseName}-${version}";

  src = fetchurl {
    url = "https://bitbucket.org/purelang/pure-lang/downloads/${name}.tar.gz";
    sha256 = "0f23a17549048ca3a8f4936ea9e931feb05997390b486850936b746996350cda";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ pure ];
  propagatedBuildInputs = [ pandoc gawk getopt ];
  makeFlags = [ "libdir=$(out)/lib" "prefix=$(out)/" ];
  preInstall = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man/man1
  '';

  meta = {
    description = "Converts Sphinx-formatted Pure documentation files to Markdown and other formats using Pandoc";
    homepage = http://puredocs.bitbucket.org/pure-pandoc.html;
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ asppsa ];
  };
}
