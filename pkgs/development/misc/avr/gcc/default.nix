{ stdenv, fetchurl, gmp, mpfr, libmpc, zlib, avrbinutils, texinfo }:

let
  version = "8.2.0";
in
stdenv.mkDerivation {

  name = "avr-gcc-${version}";
  src = fetchurl {
    url = "mirror://gcc/releases/gcc-${version}/gcc-${version}.tar.xz";
    sha256 = "10007smilswiiv2ymazr3b6x2i933c0ycxrr529zh4r6p823qv0r";
  };

  patches = [
    ./avrbinutils-path.patch
  ];

  # avrbinutils-path.patch introduces a reference to @avrbinutils@, substitute
  # it now.
  postPatch = ''
    substituteInPlace gcc/gcc-ar.c --subst-var-by avrbinutils ${avrbinutils}
  '';

  buildInputs = [ gmp mpfr libmpc zlib avrbinutils ];

  nativeBuildInputs = [ texinfo ];

  hardeningDisable = [ "format" ];

  stripDebugList= [ "bin" "libexec" ];

  enableParallelBuilding = true;

  configurePhase = ''
    mkdir gcc-build
    cd gcc-build
    ../configure   \
    --prefix=$out  \
    --host=$CHOST  \
    --build=$CHOST \
    --target=avr   \
    --with-as=${avrbinutils}/bin/avr-as \
    --with-gnu-as  \
    --with-gnu-ld  \
    --with-ld=${avrbinutils}/bin/avr-ld \
    --with-system-zlib \
    --disable-install-libiberty \
    --disable-nls \
    --disable-libssp \
    --with-dwarf2 \
    --enable-languages=c,c++'';

  meta = with stdenv.lib; {
    description = "GNU Compiler Collection, version ${version} for AVR microcontrollers";
    homepage = http://gcc.gnu.org;
    license = licenses.gpl3Plus;
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ mguentner ];
  };
}
