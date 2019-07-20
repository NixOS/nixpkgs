{ stdenv, fetchurl, makeWrapper, gcc, asciidoc, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "colm-${version}";
  version = "0.13.0.7";

  src = fetchurl {
    url = "https://www.colm.net/files/colm/${name}.tar.gz";
    sha256 = "0f76iri173l2wja2v7qrwmf958cqwh5g9x4bhj2z8wknmlla6gz4";
  };

  patches = [ ./cross-compile.patch ];

  nativeBuildInputs = [ makeWrapper asciidoc autoreconfHook ];

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
