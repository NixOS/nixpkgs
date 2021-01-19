{ lib, stdenv, fetchurl, meson, ninja, pkg-config, efl }:

stdenv.mkDerivation rec {
  pname = "evisum";
  version = "0.5.9";

  src = fetchurl {
    url = "https://download.enlightenment.org/rel/apps/${pname}/${pname}-${version}.tar.xz";
    sha256 = "sha256-ao5b4Mhr+fhY19X1g0gupcU8LayR55/kgHSwhGUAfys=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    efl
  ];

  meta = with lib; {
    description = "System and process monitor written with EFL";
    homepage = "https://www.enlightenment.org";
    license = with licenses; [ isc ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
