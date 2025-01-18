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

  meta = with lib; {
    description = "Small channel scan tool which generates ATSC, DVB-C, DVB-S/S2 and DVB-T/T2 channels.conf files";
    homepage = "https://github.com/stefantalpalaru/w_scan2";
    platforms = platforms.linux;
    maintainers = with maintainers; [ _0x4A6F ];
    license = licenses.gpl2Only;
    mainProgram = "w_scan2";
  };
}
