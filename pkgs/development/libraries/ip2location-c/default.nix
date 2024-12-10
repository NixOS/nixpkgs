{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "ip2location-c";
  version = "8.6.1";

  src = fetchFromGitHub {
    owner = "chrislim2888";
    repo = "IP2Location-C-Library";
    rev = version;
    sha256 = "sha256-3/cLoGV7go4S1ew73IJzJEMTlLnvM3adl+/Sb7mPrZY=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  enableParallelBuilding = true;

  # Checks require a database, which require registration (although sample
  # databases are available, downloading them for just 1 test seems excessive):
  doCheck = false;

  meta = with lib; {
    description = "Library to look up locations of host names and IP addresses";
    mainProgram = "ip2location";
    longDescription = ''
      A C library to find the country, region, city,coordinates,
      zip code, time zone, ISP, domain name, connection type, area code,
      weather, MCC, MNC, mobile brand name, elevation and usage type of
      any IP address or host name in the IP2Location databases.
    '';
    homepage = "https://www.ip2location.com/developers/c";
    license = with licenses; [
      gpl3Plus
      lgpl3Plus
    ];
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
