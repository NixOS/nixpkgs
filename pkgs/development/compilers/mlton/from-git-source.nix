{ fetchgit
, gmp
, mltonBootstrap
, url ? "https://github.com/mlton/mlton"
, rev
, sha256
, stdenv
, version
, which
}:

stdenv.mkDerivation {
  pname = "mlton";
  inherit version;

  src = fetchgit {
    inherit url rev sha256;
  };

  nativeBuildInputs = [ which ];

  buildInputs = [mltonBootstrap gmp];

  # build fails otherwise
  enableParallelBuilding = false;

  preBuild = ''
    find . -type f | grep -v -e '\.tgz''$' | xargs sed -i "s@/usr/bin/env bash@$(type -p bash)@"
    sed -i "s|/tmp|$TMPDIR|" bin/regression

    makeFlagsArray=(
      MLTON_VERSION="${version} ${rev}"
      CC="$(type -p cc)"
      PREFIX="$out"
      WITH_GMP_INC_DIR="${gmp.dev}/include"
      WITH_GMP_LIB_DIR="${gmp}/lib"
      )
  '';

  doCheck = true;

  meta = import ./meta.nix;
}
