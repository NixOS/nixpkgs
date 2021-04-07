{ lib, stdenv, fetchurl, fetchpatch, fastjet, fastjet-contrib, ghostscript, hepmc, imagemagick, less, python3, rsync, texlive, yoda, which, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "rivet";
  version = "3.1.3";

  src = fetchurl {
    url = "https://www.hepforge.org/archive/rivet/Rivet-${version}.tar.bz2";
    sha256 = "08g0f84l7r6vm4n7gn36qi3bzacscpv061m9xar2572vf10wxpak";
  };

  patches = [
    ./darwin.patch # configure relies on impure sw_vers to -Dunix

    # fix compilation errors (fails depending on number of cores filesystem ordering?)
    # https://gitlab.com/hepcedar/rivet/-/merge_requests/220
    (fetchpatch {
      url = "https://gitlab.com/hepcedar/rivet/commit/3203bf12a4bef81f880789eb9cde7ff489ae5115.diff";
      sha256 = "0zn5yxlv6dk4vcqgz0syzb9mp4qc9smpmgshcqimcvii7qcp20mc";
    })
    # https://gitlab.com/hepcedar/rivet/-/merge_requests/223
    (fetchpatch {
      url = "https://gitlab.com/hepcedar/rivet/commit/476f267c46b126fa163a92aa6cbcb7806c4624c3.diff";
      sha256 = "0dhkraddzp06v5z0d2wf0c8vsd50hl5pqsjgsrb8x14d0vwi8rnc";
    })

    # fix for new python and fix transparency gs 9.52
    # gs 9.52 opacity fix
    (fetchpatch {
      url = "https://gitlab.com/hepcedar/rivet/commit/25c4bee19882fc56407b0a438f86e1a11753d5e6.diff";
      sha256 = "18p2wk54r0qfq6l27z6805zq1z5jhk5sbxbjixgibzq8prj1a78v";
    })

    # make-plots: fix wrong logic in Plot.set_xmax()
    (fetchpatch {
      url = "https://gitlab.com/hepcedar/rivet/commit/d371c6c10cf67a41c0e4e27c16ff5723d6276ad2.diff";
      sha256 = "0w622rd5darj7qafbbc84blznvy5rnhsdyr2n1i1fkz19mrf5h2p";
    })

    # fix https://gitlab.com/hepcedar/rivet/-/issues/200
    (fetchpatch {
      url = "https://gitlab.com/hepcedar/rivet/commit/442dbd17dcb3bd6e30b26e54c50f6a8237f966f9.diff";
      includes = [ "bin/make-pgfplots" "bin/make-plots" "bin/make-plots-fast" ];
      sha256 = "0c3rysgcib49km1zdpgsdai3xi4s6ijqgxp4whn04mrh3qf4bmr3";
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
    sansmath
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
  ] ++ (if lib.versions.major hepmc.version == "3" then [
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

  meta = with lib; {
    description = "A framework for comparison of experimental measurements from high-energy particle colliders to theory predictions";
    license     = licenses.gpl3;
    homepage    = "https://rivet.hepforge.org";
    platforms   = platforms.unix;
    maintainers = with maintainers; [ veprbl ];
  };
}
