{ lib
, stdenv
, tde
, cmake
, coreutils
, libuuid
, mesa
, pkg-config
, which
}:

stdenv.mkDerivation (finalAttrs: {
  inherit (tde.mkTDEComponent tde.sources.tqtinterface)
    pname version src;

  patches = [
    ./0001-fixup.diff
  ];

  nativeBuildInputs = [
    cmake
    coreutils
    pkg-config
    which
  ];

  buildInputs = [
    tde.tqt3
    tde.tde-cmake
    libuuid
    mesa
  ];

  cmakeFlags = [
    "-DQT_VERSION=3"
    "-DQT_PREFIX_DIR=${tde.tqt3}"
    "-DQT_INCLUDE_DIR=${lib.getDev tde.tqt3}/include"
    "-DMOC_EXECUTABLE=${lib.getBin tde.tqt3}/bin/tqmoc"
  ];

  meta = (tde.mkTDEComponent tde.sources.tqtinterface).meta;
})
