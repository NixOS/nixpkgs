{ stdenv, fetchurl, fetchpatch, fastjet, ghostscript, gsl, hepmc2, imagemagick, less, python2, texlive, yoda, which, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "rivet";
  version = "2.7.2";

  src = fetchurl {
    url = "https://www.hepforge.org/archive/rivet/Rivet-${version}.tar.bz2";
    sha256 = "1bxcb99a3l5d2gl93zgfzgw6v95kx1ss5045mkz3ciyw8w5nmb9l";
  };

  patches = [
    ./darwin.patch # configure relies on impure sw_vers to -Dunix
    (fetchpatch {
      url = "https://gitlab.com/hepcedar/rivet/commit/37bd34f52cce66946ebb311a8fe61bfc5f69cc00.diff";
      sha256 = "0wj3ilpfq2gpc33bj3800l9vyvc9lrrlj1x9ss5qki0yiqd8i2aa";
    })
  ];

  latex = texlive.combine { inherit (texlive)
    scheme-basic
    collection-pstricks
    collection-fontsrecommended
    l3kernel
    l3packages
    mathastext
    pgf
    relsize
    sfmath
    siunitx
    xcolor
    xkeyval
    xstring
    ;};
  buildInputs = [ hepmc2 imagemagick python2 latex makeWrapper ];
  propagatedBuildInputs = [ fastjet ghostscript gsl yoda ];

  preConfigure = ''
    substituteInPlace analyses/Makefile.in \
      --replace "!(tmp)" ""
    substituteInPlace bin/rivet-buildplugin.in \
      --replace 'which' '"${which}/bin/which"' \
      --replace 'mycxx=' 'mycxx=${stdenv.cc}/bin/${if stdenv.cc.isClang or false then "clang++" else "g++"}  #' \
      --replace 'mycxxflags="' "mycxxflags=\"-std=c++11 $NIX_CFLAGS_COMPILE $NIX_CXXSTDLIB_COMPILE $NIX_CFLAGS_LINK "
  '';

  preInstall = ''
    substituteInPlace bin/make-plots \
      --replace '"which"' '"${which}/bin/which"' \
      --replace '"latex"' '"${latex}/bin/latex"' \
      --replace '"dvips"' '"${latex}/bin/dvips"' \
      --replace '"ps2pdf"' '"${ghostscript}/bin/ps2pdf"' \
      --replace '"ps2eps"' '"${ghostscript}/bin/ps2eps"' \
      --replace '"kpsewhich"' '"${latex}/bin/kpsewhich"' \
      --replace '"convert"' '"${imagemagick.out}/bin/convert"'
    substituteInPlace bin/rivet \
      --replace '"less"' '"${less}/bin/less"'
    substituteInPlace bin/rivet-mkhtml \
      --replace '"make-plots"' \"$out/bin/make-plots\" \
      --replace '"rivet-cmphistos"' \"$out/bin/rivet-cmphistos\"
  '';

  configureFlags = [
    "--with-fastjet=${fastjet}"
    "--with-hepmc=${hepmc2}"
    "--with-yoda=${yoda}"
  ];

  enableParallelBuilding = true;

  postInstall = ''
    for prog in "$out"/bin/*; do
      wrapProgram "$prog" --set PYTHONPATH $PYTHONPATH:$(toPythonPath "$out")
    done
  '';

  meta = {
    description = "A framework for comparison of experimental measurements from high-energy particle colliders to theory predictions";
    license     = stdenv.lib.licenses.gpl2;
    homepage    = https://rivet.hepforge.org;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ veprbl ];
  };
}
