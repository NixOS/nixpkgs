{ stdenv, fetchurl, makeWrapper, gcc }:

stdenv.mkDerivation rec {
  name = "colm-${version}";
  version = "0.13.0.3";

  src = fetchurl {
    url = "http://www.colm.net/files/colm/${name}.tar.gz";
    sha256 = "0dadfsnkbxcrf5kihvncbprb6w64jz2myylfmj952gdmcsim4zj2";
  };

  buildInputs = [ makeWrapper ];

  doCheck = true;

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
