{ lib
, buildDunePackage
, fetchurl
, cstruct
, logs
, lwt
, macaddr
, mirage-net
<<<<<<< HEAD
=======
, mirage-profile
, ppx_cstruct
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildDunePackage rec {
  pname = "ethernet";
<<<<<<< HEAD
  version = "3.2.0";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/${pname}/releases/download/v${version}/${pname}-${version}.tbz";
    hash = "sha256-TB2nAhQiHZ1Dk6n/3i49s9HKNH92yNUl3xl94hByrAk=";
  };

=======
  version = "3.0.0";

  minimalOCamlVersion = "4.08";

  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/mirage/${pname}/releases/download/v${version}/${pname}-v${version}.tbz";
    hash = "sha256:0a898vp9dw42majsvzzvs8pc6x4ns01wlwhwbacixliv6vv78ng9";
  };

  buildInputs = [
    ppx_cstruct
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    cstruct
    mirage-net
    macaddr
<<<<<<< HEAD
=======
    mirage-profile
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    lwt
    logs
  ];

  meta = with lib; {
    description = "OCaml Ethernet (IEEE 802.3) layer, used in MirageOS";
    homepage = "https://github.com/mirage/ethernet";
    license = licenses.isc;
    maintainers = [ maintainers.sternenseemann ];
  };
}
