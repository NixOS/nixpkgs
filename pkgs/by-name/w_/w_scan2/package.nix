{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "w_scan2";
  version = "1.0.15";

  src = fetchFromGitHub {
    owner = "stefantalpalaru";
    repo = "w_scan2";
    rev = version;
    hash = "sha256-ToD02W9H9HqddhpZsQm2Uzy/cVtv4KnfYmpCl2KEGSY=";
  };

  meta = {
    description = "Small channel scan tool which generates ATSC, DVB-C, DVB-S/S2 and DVB-T/T2 channels.conf files";
    homepage = "https://github.com/stefantalpalaru/w_scan2";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ _0x4A6F ] ;
    license = lib.licenses.gpl2Only;
    mainProgram = "w_scan2";
  };
}
