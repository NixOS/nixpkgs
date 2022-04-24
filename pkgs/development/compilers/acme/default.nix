{ lib, stdenv, fetchsvn }:

stdenv.mkDerivation rec {
  pname = "acme";
  version = "unstable-2021-02-14";

  src = fetchsvn {
    url = "svn://svn.code.sf.net/p/acme-crossass/code-0/trunk";
    rev = "319";
    sha256 = "sha256-VifIQ+UEVMKJ+cNS+Xxusazinr5Cgu1lmGuhqj/5Mpk=";
  };

  sourceRoot = "code-0-r${src.rev}/src";

  makeFlags = [ "BINDIR=$(out)/bin" ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace "= gcc" "?= gcc"
  '';

  meta = with lib; {
    description = "A multi-platform cross assembler for 6502/6510/65816 CPUs";
    homepage = "https://sourceforge.net/projects/acme-crossass/";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ OPNA2608 ];
  };
}
