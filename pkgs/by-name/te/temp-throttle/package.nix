{ lib, stdenv, fetchFromGitHub }:

let
  version = "3.01";
in
stdenv.mkDerivation {
  inherit version;
  pname = "temp-throttle";
  src = fetchFromGitHub {
    owner = "Sepero";
    repo = "temp-throttle";
    rev = "v${version}";
    sha256 = "sha256-dprVBzjLbytCb6eo656XWjF0klMy3zej7FCI9fUYAmg=";
  };
  meta = with lib; {
    homepage = "https://github.com/Sepero/temp-throttle";
    description = "Linux shell script for throttling system CPU frequency based on a desired maximum temperature";
    mainProgram = "temp-throttle";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ Sepero ];
  };

  installPhase = ''
    mkdir -p $out/bin $out/etc
    cp usr/sbin/temp-throttle $out/bin/
    cp etc/temp-throttle.conf $out/etc/temp-throttle.conf.example
  '';
}

