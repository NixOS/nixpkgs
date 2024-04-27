{ lib, stdenv, fetchFromGitHub }:

let
  version = "3.01";
in
stdenv.mkDerivation {
  pname = "temp-throttle";
  inherit version;
  src = fetchFromGitHub {
    owner = "Sepero";
    repo = "temp-throttle";
    rev = "v${version}";
    sha256 = "sha256-dprVBzjLbytCb6eo656XWjF0klMy3zej7FCI9fUYAmg=";
  };
  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/etc
    mv usr/sbin/temp-throttle $out/bin/
    mv etc/temp-throttle.conf $out/etc/temp-throttle.conf.example

    runHook postInstall
  '';
  meta = {
    homepage = "https://github.com/Sepero/temp-throttle";
    description = "Linux shell script for throttling system CPU frequency based on a desired maximum temperature";
    mainProgram = "temp-throttle";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ Sepero ];
  };
}

