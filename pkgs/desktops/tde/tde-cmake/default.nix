{ lib
, stdenvNoCC
, tde
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  inherit (tde.mkTDEComponent tde.sources.tde-cmake)
    pname version src;

  # CMakeLists.txt tries to install things at CMAKE_ROOT. It is better to ignore
  # it and use a setupHook.
  installPhase = ''
    runHook preInstall

    mkdir -pv $out/lib/cmake
    cp -R modules templates $out/lib/cmake/

    runHook postInstall
  '';

  setupHook = ./setup-hook.sh;

  inherit (tde.mkTDEComponent tde.sources.tde-cmake) meta;
})
