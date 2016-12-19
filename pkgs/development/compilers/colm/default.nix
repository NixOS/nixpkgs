{ stdenv, fetchurl, makeWrapper, gcc }:

stdenv.mkDerivation rec {
  name = "colm-${version}";
  version = "0.13.0.4";

  src = fetchurl {
    url = "http://www.colm.net/files/colm/${name}.tar.gz";
    sha256 = "04xcb7w82x9i4ygxqla9n39y646n3jw626khdp5297z1dkxx1czx";
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
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ pSub ];
  };
}
