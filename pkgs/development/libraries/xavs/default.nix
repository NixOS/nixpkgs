{ lib, stdenv, fetchsvn }:

stdenv.mkDerivation rec {
  pname = "xavs";
  version = "55";

  src = fetchsvn {
    url = "https://svn.code.sf.net/p/xavs/code/trunk";
    rev = version;
    sha256 = "0drw16wm95dqszpl7j33y4gckz0w0107lnz6wkzb66f0dlbv48cf";
  };

  enableParallelBuilding = true;

  patchPhase = ''
    patchShebangs configure
    patchShebangs config.sub
    patchShebangs version.sh
    patchShebangs tools/countquant_xavs.pl
    patchShebangs tools/patcheck
    patchShebangs tools/regression-test.pl
    patchShebangs tools/xavs-format
    '' + lib.optionalString stdenv.isDarwin ''
    substituteInPlace config.guess --replace-fail 'uname -p' 'uname -m'
    substituteInPlace configure \
      --replace-fail '-O4' '-O3' \
      --replace-fail ' -s ' ' ' \
      --replace-fail 'LDFLAGS -s' 'LDFLAGS' \
      --replace-fail '-dynamiclib' ' ' \
      --replace-fail '-falign-loops=16' ' '
    substituteInPlace Makefile --replace-fail '-Wl,-soname,' ' '
    '';

  configureFlags = [
    "--enable-pic"
    "--enable-shared"
    # Bug preventing compilation with assembly enabled
    "--disable-asm"
  ];

  meta = with lib; {
    description = "AVS encoder and decoder";
    mainProgram = "xavs";
    homepage    = "https://xavs.sourceforge.net/";
    license     = licenses.lgpl2;
    platforms   = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ codyopel ];
  };
}
