{
  stdenv,
  libayatana-appindicator,
}:

{ version, src, ... }:

stdenv.mkDerivation {
  pname = "system_tray";
  inherit version src;
  inherit (src) passthru;

  installPhase = ''
    runHook preInstall

    substituteInPlace linux/tray.cc \
      --replace-fail "libappindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
    cp -r . "$out"

    runHook postInstall
  '';
}
