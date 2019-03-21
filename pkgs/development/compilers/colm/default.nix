{ stdenv, fetchurl, makeWrapper, gcc, asciidoc }:

stdenv.mkDerivation rec {
  name = "colm-${version}";
  version = "0.13.0.6";

  src = fetchurl {
    url = "https://www.colm.net/files/colm/${name}.tar.gz";
    sha256 = "0jd3qmqdm8yszy0yysbp3syk7pcbxvwzv9mibdwz7v9bv1nrai26";
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
    platforms = platforms.unix;
    maintainers = with maintainers; [ pSub ];
  };
}
