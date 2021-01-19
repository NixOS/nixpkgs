{ stdenv, fetchsvn }:

stdenv.mkDerivation rec {
  pname = "acme";
  version = "unstable-2020-12-27";

  src = fetchsvn {
    url = "svn://svn.code.sf.net/p/acme-crossass/code-0/trunk";
    rev = "314";
    sha256 = "08zg26rh19nlif7id91nv0syx5n243ssxhfw0nk2r2bhjm5jrjz1";
  };

  sourceRoot = "code-0-r${src.rev}/src";

  makeFlags = [ "BINDIR=$(out)/bin" ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace "= gcc" "?= gcc"
  '';

  meta = with stdenv.lib; {
    description = "A multi-platform cross assembler for 6502/6510/65816 CPUs";
    homepage = "https://sourceforge.net/projects/acme-crossass/";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ OPNA2608 ];
  };
}
