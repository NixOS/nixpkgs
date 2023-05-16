{ lib
, stdenv
, buildDunePackage
, fetchurl
, cstruct
, duration
, ethernet
, ipaddr
, logs
, lwt
, macaddr
<<<<<<< HEAD
=======
, mirage-profile
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, mirage-time
, alcotest
, mirage-clock-unix
, mirage-flow
, mirage-random
, mirage-random-test
, mirage-time-unix
, mirage-vnetif
, bisect_ppx
}:

buildDunePackage rec {
  pname = "arp";
<<<<<<< HEAD
  version = "3.1.0";

  src = fetchurl {
    url = "https://github.com/mirage/${pname}/releases/download/v${version}/${pname}-${version}.tbz";
    hash = "sha256-g/aEhpufQcyS/vCtKk0Z1sYaYNRmQFaZ9rTp9F4nq54=";
  };

  minimalOCamlVersion = "4.08";
=======
  version = "3.0.0";

  src = fetchurl {
    url = "https://github.com/mirage/${pname}/releases/download/v${version}/${pname}-v${version}.tbz";
    sha256 = "1x3l8v96ywc3wrcwbf0j04b8agap4fif0fz6ki2ndzx57yqcjszn";
  };

  minimalOCamlVersion = "4.08";
  duneVersion = "3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [
    bisect_ppx
  ];

  propagatedBuildInputs = [
    cstruct
    duration
    ethernet
    ipaddr
    logs
    lwt
    macaddr
<<<<<<< HEAD
=======
    mirage-profile
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    mirage-time
  ];

  ## NOTE: As of 18 april 2023 and ARP version 3.0.0, tests fail on Darwin.
  doCheck = ! stdenv.isDarwin;
  checkInputs = [
    alcotest
    mirage-clock-unix
    mirage-flow
    mirage-random
    mirage-random-test
    mirage-time-unix
    mirage-vnetif
  ];

  meta = with lib; {
    description = "Address Resolution Protocol purely in OCaml";
    homepage = "https://github.com/mirage/arp";
    license = licenses.isc;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
