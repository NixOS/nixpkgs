{ stdenv, fetchurl, fetchpatch, python2Packages, root, makeWrapper, withRootSupport ? false }:

stdenv.mkDerivation rec {
  name = "yoda-${version}";
  version = "1.6.6";

  src = fetchurl {
    url = "http://www.hepforge.org/archive/yoda/YODA-${version}.tar.bz2";
    sha256 = "088xx4q6b03bnj6xg5189m8wsznhal8aj3jk40sbj24idm4jl5yg";
  };

  pythonPath = []; # python wrapper support

  patches = [
    (fetchpatch {
      url = "https://yoda.hepforge.org/hg/yoda/rev/3dbc8927e715?style=raw";
      sha256 = "02rm34z9lbab66p7gpij12qwdph5fddpksg80qz0m537wjwy2ddy";
    })
    (fetchpatch {
      url = "https://yoda.hepforge.org/hg/yoda/rev/669c2be582ef?style=raw";
      sha256 = "0s705cl3bazpvpvy46vv1k223knwxq2yy5na1c6lv217sq9w86wj";
    })
  ];

  buildInputs = with python2Packages; [ python numpy matplotlib makeWrapper ]
    ++ stdenv.lib.optional withRootSupport root;

  enableParallelBuilding = true;

  postInstall = ''
    for prog in "$out"/bin/*; do
      wrapProgram "$prog" --set PYTHONPATH $PYTHONPATH:$(toPythonPath "$out")
    done
  '';

  meta = {
    description = "Provides small set of data analysis (specifically histogramming) classes";
    license     = stdenv.lib.licenses.gpl2;
    homepage    = https://yoda.hepforge.org;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ veprbl ];
  };
}
