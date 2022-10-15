{ stdenv, lib, autoPatchelfHook, fetchzip, xz, ncurses5, readline, gmp, mpfr
, expat, libipt, zlib, dejagnu, sourceHighlight, python3, elfutils, guile, glibc
}:

stdenv.mkDerivation rec {
  pname = "gnatboot";
  version = "12.1.0-2";

  src = fetchzip {
    url = "https://github.com/alire-project/GNAT-FSF-builds/releases/download/gnat-${version}/gnat-x86_64-linux-${version}.tar.gz";
    hash = "sha256-EPDPOOjWJnJsUM7GGxj20/PXumjfLoMIEFX1EDtvWVY=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dejagnu
    elfutils
    expat
    glibc
    gmp
    guile
    libipt
    mpfr
    ncurses5
    python3
    readline
    sourceHighlight
    xz
    zlib
  ];

  installPhase = ''
    mkdir -p $out
    cp -ar * $out/
  '';

  passthru = {
    langC = true; # TRICK for gcc-wrapper to wrap it
    langCC = false;
    langFortran = false;
    langAda = true;
  };

  meta = with lib; {
    description = "GNAT, the GNU Ada Translator";
    homepage = "https://www.gnu.org/software/gnat";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ethindp ];
    platforms = [ "x86_64-linux" ];
  };
}
