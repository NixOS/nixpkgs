{ mkDerivation, lib
, extra-cmake-modules
, libksysguard, libnl, lm_sensors, networkmanager-qt
}:

mkDerivation {
  pname = "ksystemstats";
  NIX_CFLAGS_COMPILE = [ "-I${lib.getBin libksysguard}/share" ];
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ libksysguard libnl lm_sensors networkmanager-qt ];
}
