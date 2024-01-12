{ lib
, stdenv
, cmake
, fetchgit
, pkg-config
, ubus
, libubox
, ucode
, json_c
}:

stdenv.mkDerivation {
  pname = "udebug";
  version = "unstable-2023-11-28";

  src = fetchgit {
    url = "https://git.openwrt.org/project/udebug.git";
    rev = "d49aadabb7a147b99a3e6299a77d7fda4e266091";
    hash = "sha256-5I50q+oUQ5f82ngKl7bX50J+3pBviNk3iVEChNjt5wY=";
  };

  buildInputs = [
    ubus
    libubox
    ucode
    json_c
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  meta = with lib; {
    description = "OpenWrt debugging helper library/service";
    homepage = "https://git.openwrt.org/?p=project/udebug.git;a=summary";
    license = licenses.free;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mkg20001 ];
  };
}
