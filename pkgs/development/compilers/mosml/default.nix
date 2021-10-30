{ lib, stdenv, fetchurl, gmp, perl }:

stdenv.mkDerivation rec {
  pname = "mosml";
  version = "2.10.1";

  buildInputs = [ gmp perl ];

  makeFlags = [ "PREFIX=$(out)" "CC=${stdenv.cc.targetPrefix}cc" ];

  src = fetchurl {
    url = "https://github.com/kfl/mosml/archive/ver-${version}.tar.gz";
    sha256 = "13x7wj94p0inn84pzpj52dch5s9lznqrj287bd3nk3dqd0v3kmgy";
  };

  setSourceRoot = ''export sourceRoot="$(echo */src)"'';

  # MosML needs a specific RPATH entry pointing to $(out)/lib (added
  # by the build system), which patchelf will remove.
  dontPatchELF = true;

  meta = with lib; {
    description = "A light-weight implementation of Standard ML";
    longDescription = ''
      Moscow ML is a light-weight implementation of Standard ML (SML), a strict
      functional language used in teaching and research.
    '';
    homepage = "https://mosml.org/";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ vaibhavsagar ];
  };
}
