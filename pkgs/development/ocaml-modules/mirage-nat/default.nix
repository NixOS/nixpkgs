{ lib, buildDunePackage, fetchurl
, ipaddr, cstruct, logs, lru
, tcpip, ethernet
, alcotest, mirage-clock-unix
}:

buildDunePackage rec {
  pname = "mirage-nat";
<<<<<<< HEAD
  version = "3.0.2";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/${pname}/releases/download/v${version}/${pname}-${version}.tbz";
    hash = "sha256-Z1g3qb26x/S6asYv6roTW77r41SHy7OGN7MoZJ/E8Is=";
=======
  version = "3.0.1";

  minimalOCamlVersion = "4.08";

  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/mirage/${pname}/releases/download/v${version}/${pname}-${version}.tbz";
    hash = "sha256-wReySOMulGkrPD60XxpgMrUoHzY9hQ7TZzYQyJ3eiik=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    ipaddr
    cstruct
    logs
    lru
    tcpip
    ethernet
  ];

  doCheck = true;
  checkInputs = [
    alcotest
    mirage-clock-unix
  ];

  meta = with lib; {
    description = "Mirage-nat is a library for network address translation to be used with MirageOS";
    homepage = "https://github.com/mirage/${pname}";
    license = licenses.isc;
    maintainers = [ maintainers.sternenseemann ];
  };
}
