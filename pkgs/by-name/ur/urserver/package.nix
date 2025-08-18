{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  bluez,
  libX11,
  libXtst,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "urserver";
  version = "3.14.0.2574";

  src = fetchurl {
    url = "https://www.unifiedremote.com/static/builds/server/linux-x64/${builtins.elemAt (builtins.splitVersion finalAttrs.version) 3}/urserver-${finalAttrs.version}.tar.gz";
    hash = "sha256-4wA2VPb5QN30TWa72pUVTYfvsxlGTO8Vngh7wDHXhDE=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    (lib.getLib stdenv.cc.cc)
    bluez
    libX11
    libXtst
  ];

  installPhase = ''
    install -m755 -D urserver $out/bin/urserver
    wrapProgram $out/bin/urserver --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath finalAttrs.buildInputs}"
    cp -r remotes $out/bin/remotes
    cp -r manager $out/bin/manager
  '';

  meta = with lib; {
    homepage = "https://www.unifiedremote.com/";
    description = "One-and-only remote for your computer";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ sfrijters ];
    platforms = [ "x86_64-linux" ];
  };
})
