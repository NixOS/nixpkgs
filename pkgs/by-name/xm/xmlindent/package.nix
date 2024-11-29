{ lib, stdenv, fetchurl, flex }:

stdenv.mkDerivation rec {
  pname = "xmlindent";
  version = "0.2.17";

  src = fetchurl {
    url = "mirror://sourceforge/project/xmlindent/xmlindent/${version}/${pname}-${version}.tar.gz";
    sha256 = "0k15rxh51a5r4bvfm6c4syxls8al96cx60a9mn6pn24nns3nh3rs";
  };

  buildInputs = [ flex ];

  preConfigure = ''
    substituteInPlace Makefile --replace "PREFIX=/usr/local" "PREFIX=$out"
  '';

  meta = {
    description = "XML stream reformatter";
    mainProgram = "xmlindent";
    homepage = "https://xmlindent.sourceforge.net/";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
