{ stdenv, fetchurl, makeWrapper, gcc, asciidoc }:

stdenv.mkDerivation rec {
  name = "colm-${version}";
  version = "0.13.0.5";

  src = fetchurl {
    url = "http://www.colm.net/files/colm/${name}.tar.gz";
    sha256 = "1320bx96ycd1xwww137cixrb983838wnrgkfsym8x5bnf5kj9rik";
  };

  nativeBuildInputs = [ makeWrapper asciidoc ];

  doCheck = true;

  postInstall = ''
    wrapProgram $out/bin/colm \
      --prefix PATH ":" ${gcc}/bin
  '';

  meta = with stdenv.lib; {
    description = "A programming language for the analysis and transformation of computer languages";
    homepage = http://www.colm.net/open-source/colm;
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ pSub ];
  };
}
