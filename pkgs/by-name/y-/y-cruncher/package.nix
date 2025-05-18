{
  stdenvNoCC,
  lib,
  fetchurl,
  autoPatchelfHook,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "y-cruncher";
  version = "0.8.6.9545";

  src = fetchurl {
    url = "https://cdn.numberworld.org/y-cruncher-downloads/y-cruncher%20v${finalAttrs.version}-static.tar.xz";
    hash = "sha256-R57uTP45CXGi3+dcH0eyxR2ewjZKNxIyGHyh6mh7FUk=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ autoPatchelfHook ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r y-cruncher\ v${finalAttrs.version}-static/* $out/bin/
    chmod +x $out/bin/y-cruncher

    runHook postInstall
  '';

  meta = {
    description = "Compute Pi and other constants to billions of digits";
    homepage = "https://www.numberworld.org/y-cruncher/";
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ savalet ];
  };
})
