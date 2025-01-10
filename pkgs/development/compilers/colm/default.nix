{ lib, stdenv, fetchurl, makeWrapper, gcc, asciidoc, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "colm";
  version = "0.13.0.7";

  src = fetchurl {
    url = "https://www.colm.net/files/colm/${pname}-${version}.tar.gz";
    sha256 = "0f76iri173l2wja2v7qrwmf958cqwh5g9x4bhj2z8wknmlla6gz4";
  };

  patches = [ ./cross-compile.patch ];

  nativeBuildInputs = [ makeWrapper asciidoc autoreconfHook ];

  doCheck = true;

  postInstall = ''
    wrapProgram $out/bin/colm \
      --prefix PATH ":" ${gcc}/bin
  '';

  meta = with lib; {
    description = "Programming language for the analysis and transformation of computer languages";
    mainProgram = "colm";
    homepage = "http://www.colm.net/open-source/colm";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ pSub ];
  };
}
