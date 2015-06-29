{ stdenv, fetchurl, makeWrapper, gcc }:

stdenv.mkDerivation rec {
  name = "colm-${version}";
  version = "0.12.0";

  src = fetchurl {
    url = "http://www.colm.net/files/colm/${name}.tar.gz";
    sha256 = "0kbfipxv3nvggd1a2nahk3jg22iifp2l7lkm55i5r7qkpms5sm3v";
  };

  buildInputs = [ makeWrapper ];

  doCheck = true;
  checkPhase = ''sh ./test/runtests.sh'';

  postInstall = ''
    wrapProgram $out/bin/colm \
      --prefix PATH ":" ${gcc}/bin
  '';

  meta = with stdenv.lib; {
    description = "A programming language for the analysis and transformation of computer languages";
    homepage = http://www.colm.net/open-source/colm;
    license = licenses.gpl2;
    maintainers = with maintainers; [ pSub ];
  };
}
