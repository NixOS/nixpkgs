{ lib, stdenv, fetchurl, meson, ninja, pkg-config, efl }:

stdenv.mkDerivation rec {
  pname = "evisum";
  version = "0.5.13";

  src = fetchurl {
    url = "https://download.enlightenment.org/rel/apps/${pname}/${pname}-${version}.tar.xz";
    sha256 = "sha256-TMVxx7D9wdujyN6PcbIxC8M6zby5myvxO9AqolrcWOY=";
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
