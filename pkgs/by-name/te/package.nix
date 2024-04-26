{ lib, stdenv,  pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
  pname = "temp-throttle";
  version = "3.01";
  src = pkgs.fetchFromGitHub {
    owner = "Sepero";
    repo = "temp-throttle";
    rev = "fd4a429a3cba0eb980f91c81e9ef5bd70f4d94c2";
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

