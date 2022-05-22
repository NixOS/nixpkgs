{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, bison
, flex
, perl
, gmp
, mpfr
, qtbase
, enableGist ? true
}:

stdenv.mkDerivation rec {
  pname = "gecode";
  version = "6.2.0";

  src = fetchFromGitHub {
    owner = "Gecode";
    repo = "gecode";
    rev = "release-${version}";
    sha256 = "0b1cq0c810j1xr2x9y9996p894571sdxng5h74py17c6nr8c6dmk";
  };

  patches = [
    # https://github.com/Gecode/gecode/pull/74
    (fetchpatch {
      name = "fix-const-weights-clang.patch";
      url = "https://github.com/Gecode/gecode/commit/c810c96b1ce5d3692e93439f76c4fa7d3daf9fbb.patch";
      sha256 = "0270msm22q5g5sqbdh8kmrihlxnnxqrxszk9a49hdxd72736p4fc";
    })
  ];

  enableParallelBuilding = true;
  dontWrapQtApps = true;
  nativeBuildInputs = [ bison flex ];
  buildInputs = [ perl gmp mpfr ]
    ++ lib.optional enableGist qtbase;

  meta = with lib; {
    license = licenses.mit;
    homepage = "https://www.gecode.org";
    description = "Toolkit for developing constraint-based systems";
    platforms = platforms.all;
    maintainers = [ ];
  };
}
