{ stdenv, lib, autoPatchelfHook, fetchzip, lzma, ncurses5, readline, gmp, mpfr
, expat, libipt, zlib, dejagnu, sourceHighlight, python3, elfutils, guile, glibc
}:

stdenv.mkDerivation rec {
  pname = "gnatboot";
  version = "11.2.0-4";
  src = fetchzip {
    url =
      "https://github.com/alire-project/GNAT-FSF-builds/releases/download/gnat-"
      + version + "/gnat-x86_64-linux-" + version + ".tar.gz";
    hash = "sha256-8fMBJp6igH+Md5jE4LMubDmC4GLt4A+bZG/Xcz2LAJQ=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    lzma
    ncurses5
    readline
    gmp
    mpfr
    expat
    libipt
    zlib
    dejagnu
    sourceHighlight
    python3
    elfutils
    guile
    glibc
  ];

  propagatedNativeBuildInputs = [
    autoPatchelfHook
    lzma
    ncurses5
    readline
    gmp
    mpfr
    expat
    libipt
    zlib
    dejagnu
    sourceHighlight
    python3
    elfutils
    guile
    glibc
  ];

  buildInputs = [
    autoPatchelfHook
    lzma
    ncurses5
    readline
    gmp
    mpfr
    expat
    libipt
    zlib
    dejagnu
    sourceHighlight
    python3
    elfutils
    guile
    glibc
  ];

  propagatedBuildInputs = [
    autoPatchelfHook
    lzma
    ncurses5
    readline
    gmp
    mpfr
    expat
    libipt
    zlib
    dejagnu
    sourceHighlight
    python3
    elfutils
    guile
    glibc
  ];

  installPhase = ''
    mkdir -p $out
    cp -var * $out/
  '';

  passthru = {
    langC = true;
    langCC = false;
    langFortran = false;
    langAda = true;
  };

  meta = with lib; {
    description = "GNAT, the GNU Ada Translator";
    homepage = "https://www.gnu.org/software/gnat";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ethindp ];
    platforms = with platforms; [ "x86_64-linux" ];
  };
}
