{ lib, stdenv, fetchurl, fetchpatch, python, root, makeWrapper, zlib, withRootSupport ? false }:

stdenv.mkDerivation rec {
  pname = "yoda";
  version = "1.9.0";

  src = fetchurl {
    url = "https://www.hepforge.org/archive/yoda/YODA-${version}.tar.bz2";
    sha256 = "1x7xi6w7lb92x8202kbaxgqg1sly534wana4f38l3gpbzw9dwmcs";
  };

  patches = [
    # fix a minor bug
    # https://gitlab.com/hepcedar/yoda/-/merge_requests/38
    (fetchpatch {
      name = "yoda-fix-fuzzy-compare-bin2d.patch";
      url = "https://gitlab.com/hepcedar/yoda/-/commit/a2999d78cb3d9ed874f367bad375dc39a1a11148.diff";
      sha256 = "sha256-BsaVm+4VtCvRoEuN4r6A4bj9XwgMe75UesKzN+b56Qw=";
    })
    # fix a regression
    # https://gitlab.com/hepcedar/yoda/-/merge_requests/40
    (fetchpatch {
      name = "yoda-fix-for-yodagz.patch";
      url = "https://gitlab.com/hepcedar/yoda/-/commit/3338ba5a7466599ac6969e4ae462f133d6cf4fd8.diff";
      sha256 = "sha256-MZTOIt468bdPCS7UVfr5hQZUsVy3TpY/TjRrNySIL70=";
      excludes = [ "ChangeLog" ];
    })
    # fix a minor bug
    # https://gitlab.com/hepcedar/yoda/-/merge_requests/45
    (fetchpatch {
      name = "yoda-fix-yodascale-for-gz.patch";
      url = "https://gitlab.com/hepcedar/yoda/-/commit/b03162aeaa2c99e38512ba6e4818d2e0a825b757.diff";
      sha256 = "sha256-IMuPalQ/GKcdJOKAlwE/IRWtxDdu0inoj+A9nbRl6Gs=";
    })
  ];

  nativeBuildInputs = with python.pkgs; [ cython makeWrapper ];
  buildInputs = [ python ]
    ++ (with python.pkgs; [ numpy matplotlib ])
    ++ lib.optional withRootSupport root;
  propagatedBuildInputs = [ zlib ];

  enableParallelBuilding = true;

  postPatch = ''
    touch pyext/yoda/*.{pyx,pxd}
    patchShebangs .
  '';

  postInstall = ''
    for prog in "$out"/bin/*; do
      wrapProgram "$prog" --set PYTHONPATH $PYTHONPATH:$(toPythonPath "$out")
    done
  '';

  hardeningDisable = [ "format" ];

  doInstallCheck = true;
  installCheckTarget = "check";

  meta = {
    description = "Provides small set of data analysis (specifically histogramming) classes";
    license     = lib.licenses.gpl3;
    homepage    = "https://yoda.hepforge.org";
    platforms   = lib.platforms.unix;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
