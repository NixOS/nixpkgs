{ mkDerivation, lib
, extra-cmake-modules
, libksysguard, libnl, lm_sensors, networkmanager-qt
}:

mkDerivation {
  name = "ksystemstats";
  NIX_CFLAGS_COMPILE = [ "-I${libksysguard.bin}/share" ];
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ libksysguard libnl lm_sensors networkmanager-qt ];
}
