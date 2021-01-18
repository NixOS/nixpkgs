{ stdenv, fetchurl, fastjet, fastjet-contrib, ghostscript, gsl, hepmc, imagemagick, less, python3, rsync, texlive, yoda, which, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "rivet";
  version = "3.1.3";

  src = fetchurl {
    url = "https://www.hepforge.org/archive/rivet/Rivet-${version}.tar.bz2";
    sha256 = "08g0f84l7r6vm4n7gn36qi3bzacscpv061m9xar2572vf10wxpak";
  };

  patches = [
    ./darwin.patch # configure relies on impure sw_vers to -Dunix
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

  nativeBuildInputs = [ rsync makeWrapper ];
  buildInputs = [ hepmc imagemagick python3 latex python3.pkgs.yoda ];
  propagatedBuildInputs = [ fastjet fastjet-contrib ];

  preConfigure = ''
    substituteInPlace bin/rivet-build.in \
      --replace 'num_jobs=$(getconf _NPROCESSORS_ONLN)' 'num_jobs=''${NIX_BUILD_CORES:-$(getconf _NPROCESSORS_ONLN)}' \
      --replace 'which' '"${which}/bin/which"' \
      --replace 'mycxx=' 'mycxx=${stdenv.cc}/bin/${if stdenv.cc.isClang or false then "clang++" else "g++"}  #' \
      --replace 'mycxxflags="' "mycxxflags=\"$NIX_CFLAGS_COMPILE $NIX_CXXSTDLIB_COMPILE $NIX_CFLAGS_LINK "
  '';

  preInstall = ''
    substituteInPlace bin/make-plots \
      --replace '"which"' '"${which}/bin/which"' \
      --replace '"latex"' '"'$latex'/bin/latex"' \
      --replace '"dvips"' '"'$latex'/bin/dvips"' \
      --replace '"ps2pdf"' '"${ghostscript}/bin/ps2pdf"' \
      --replace '"ps2eps"' '"${ghostscript}/bin/ps2eps"' \
      --replace '"kpsewhich"' '"'$latex'/bin/kpsewhich"' \
      --replace '"convert"' '"${imagemagick.out}/bin/convert"'
    substituteInPlace bin/rivet \
      --replace '"less"' '"${less}/bin/less"'
    substituteInPlace bin/rivet-mkhtml \
      --replace '"make-plots"' \"$out/bin/make-plots\" \
      --replace '"rivet-cmphistos"' \"$out/bin/rivet-cmphistos\"
  '';

  configureFlags = [
    "--with-fastjet=${fastjet}"
    "--with-yoda=${yoda}"
  ] ++ (if stdenv.lib.versions.major hepmc.version == "3" then [
    "--with-hepmc3=${hepmc}"
  ] else [
    "--with-hepmc=${hepmc}"
  ]);

  enableParallelBuilding = true;

  postInstall = ''
    for prog in "$out"/bin/*; do
      wrapProgram "$prog" --set PYTHONPATH $PYTHONPATH:$(toPythonPath "$out")
    done
  '';

  meta = with stdenv.lib; {
    description = "A framework for comparison of experimental measurements from high-energy particle colliders to theory predictions";
    license     = licenses.gpl3;
    homepage    = "https://rivet.hepforge.org";
    platforms   = platforms.unix;
    maintainers = with maintainers; [ veprbl ];
  };
}
