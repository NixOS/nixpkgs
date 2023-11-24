{ lib, stdenv, fetchsvn }:

stdenv.mkDerivation rec {
  pname = "acme";
  version = "unstable-2021-11-05";

  src = fetchsvn {
    url = "svn://svn.code.sf.net/p/acme-crossass/code-0/trunk";
    rev = "323";
    sha256 = "1dzvip90yf1wg0fhfghn96dwrhg289d06b624px9a2wwy3vp5ryg";
  };

  sourceRoot = "${src.name}/src";

  postPatch = ''
    substituteInPlace Makefile \
      --replace "= gcc" "?= gcc"
  '';

  enableParallelBuilding = true;

  makeFlags = [ "BINDIR=$(out)/bin" ];

  meta = with lib; {
    description = "A multi-platform cross assembler for 6502/6510/65816 CPUs";
    homepage = "https://sourceforge.net/projects/acme-crossass/";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ OPNA2608 ];
  };
}
