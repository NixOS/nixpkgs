{ stdenv, fetchsvn }:

stdenv.mkDerivation rec {
  pname = "acme";
  version = "120";

  src = fetchsvn {
    url = "svn://svn.code.sf.net/p/acme-crossass/code-0/trunk";
    rev = version;
    sha256 = "0w17b8f8bis22m6l5bg8qg8nniy20f8yg2xmzjipblmc39vpv6s2";
  };

  sourceRoot = "code-0-r${src.rev}/src";

  makeFlags = [ "BINDIR=$(out)/bin" ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace "= gcc" "?= gcc"
  '';

  meta = with stdenv.lib; {
    description = "A multi-platform cross assembler for 6502/6510/65816 CPUs.";
    homepage = "https://sourceforge.net/projects/acme-crossass/";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ OPNA2608 ];
  };
}
