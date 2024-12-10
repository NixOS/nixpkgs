{ lib, stdenv, fetchurl, fastjet, fastjet-contrib, ghostscript, hdf5, hepmc3, highfive, imagemagick, less, pkg-config, python3, rsync, texliveBasic, yoda, which, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "rivet";
  version = "4.0.2";

  src = fetchurl {
    url = "https://www.hepforge.org/archive/rivet/Rivet-${version}.tar.bz2";
    hash = "sha256-ZaOzb0K/94LtJ2eTDmaeCbFAiZYF15cvyPd3hbSogsA=";
  };

  latex = texliveBasic.withPackages (ps: with ps; [
    collection-pstricks
    collection-fontsrecommended
    l3kernel
    l3packages
    mathastext
    pgf
    relsize
    sansmath
    sfmath
    siunitx
    xcolor
    xkeyval
    xstring
  ]);

  nativeBuildInputs = [ rsync makeWrapper pkg-config ];
  buildInputs = [ hepmc3 highfive imagemagick python3 latex python3.pkgs.yoda ];
  propagatedBuildInputs = [ hdf5 fastjet fastjet-contrib ];

  preConfigure = ''
    substituteInPlace configure \
      --replace-fail 'if test $HEPMC_VERSION -le 310; then' 'if false; then'
    substituteInPlace bin/rivet-build.in \
      --replace-fail 'num_jobs=$(getconf _NPROCESSORS_ONLN)' 'num_jobs=''${NIX_BUILD_CORES:-$(getconf _NPROCESSORS_ONLN)}' \
      --replace-fail 'which' '"${which}/bin/which"' \
      --replace-fail 'mycxx=' 'mycxx=${stdenv.cc}/bin/${if stdenv.cc.isClang or false then "clang++" else "g++"}  #' \
      --replace-fail 'mycxxflags="' "mycxxflags=\"$NIX_CFLAGS_COMPILE $NIX_CXXSTDLIB_COMPILE $NIX_CFLAGS_LINK "
  '';

  preInstall = ''
    substituteInPlace bin/make-plots \
      --replace-fail '"which"' '"${which}/bin/which"' \
      --replace-fail '"latex"' '"'$latex'/bin/latex"' \
      --replace-fail '"dvips"' '"'$latex'/bin/dvips"' \
      --replace-fail '"ps2pdf"' '"${ghostscript}/bin/ps2pdf"' \
      --replace-fail '"ps2eps"' '"${ghostscript}/bin/ps2eps"' \
      --replace-fail '"kpsewhich"' '"'$latex'/bin/kpsewhich"' \
      --replace-fail '"convert"' '"${imagemagick.out}/bin/convert"'
    substituteInPlace bin/rivet \
      --replace-fail '"less"' '"${less}/bin/less"'
    substituteInPlace bin/rivet-mkhtml-tex \
      --replace-fail '"make-plots"' \"$out/bin/make-plots\" \
      --replace-fail '"rivet-cmphistos"' \"$out/bin/rivet-cmphistos\" \
      --replace-fail 'ch_cmd = [sys.executable, os.path.join(os.path.dirname(__file__),' 'ch_cmd = [('
  '';

  configureFlags = [
    "--with-fastjet=${fastjet}"
    "--with-yoda=${yoda}"
    "--with-hepmc3=${hepmc3}"
    "--with-highfive=${highfive}"
  ];

  enableParallelBuilding = true;

  postInstall = ''
    for prog in "$out"/bin/*; do
      wrapProgram "$prog" --set PYTHONPATH $PYTHONPATH:$(toPythonPath "$out")
    done
  '';

  meta = with lib; {
    description = "Framework for comparison of experimental measurements from high-energy particle colliders to theory predictions";
    license     = licenses.gpl3;
    homepage    = "https://rivet.hepforge.org";
    platforms   = platforms.unix;
    maintainers = with maintainers; [ veprbl ];
  };
}
