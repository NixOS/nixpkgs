{ stdenv
, fetchurl
, fetchpatch
, gmp
, autoreconfHook
}:

stdenv.mkDerivation rec {
  name = "cddlib-${version}";
  version = "0.94i";
  src = let
    fileVersion = stdenv.lib.replaceStrings ["."] [""] version;
  in fetchurl {
    # Might switch to github in the future, see
    # https://trac.sagemath.org/ticket/21952#comment:20
    urls = [
      "http://archive.ubuntu.com/ubuntu/pool/universe/c/cddlib/cddlib_${fileVersion}.orig.tar.gz"
      "ftp://ftp.math.ethz.ch/users/fukudak/cdd/cddlib-${fileVersion}.tar.gz"
    ];
    sha256 = "00zdgiqb91vx6gd2103h3ijij0llspsxc6zz3iw2bll39fvkl4xq";
  };
  buildInputs = [gmp];
  nativeBuildInputs = [
    autoreconfHook
  ];
  # compute reduced H and V representation of polytope
  # this patch is included by most distributions (Debian, Conda, ArchLinux, SageMath)
  # proposed upstream (no answer yet): https://github.com/cddlib/cddlib/pull/3
  both_reps_c = (fetchurl {
    name = "cdd_both_reps.c";
    url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/sci-libs/cddlib/files/cdd_both_reps.c?id=56bd759df1d0c750a065b8c845e93d5dfa6b549d";
    sha256 = "0r9yc5bgiz8i72c6vsn2y2mjk5581iw94gji9v7lg16kzzgrk9x0";
  });
  preAutoreconf = ''
    # Required by sage.geometry.polyhedron
    cp ${both_reps_c} src/cdd_both_reps.c
    cp ${both_reps_c} src-gmp/cdd_both_reps.c
  '';
  patches = [
    # add the cdd_both_reps binary
    (fetchpatch {
      name = "add-cdd_both_reps-binary.patch";
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/sci-libs/cddlib/files/cddlib-094h-add-cdd_both_reps-binary.patch?id=78e3a61a68c916450aa4e5ceecd20041583af901";
      sha256 = "162ni2fr7dpbdkz0b5nizxq7qr5k1i1d75g0smiylpzfb0hb761a";
    })
  ];
  meta = {
    inherit version;
    description = ''An implementation of the Double Description Method for generating all vertices of a convex polyhedron'';
    license = stdenv.lib.licenses.gpl2Plus ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = https://www.inf.ethz.ch/personal/fukudak/cdd_home/index.html;
  };
}
