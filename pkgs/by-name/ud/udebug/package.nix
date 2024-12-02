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
  version = "unstable-2023-12-06";

  src = fetchgit {
    url = "https://git.openwrt.org/project/udebug.git";
    rev = "6d3f51f9fda706f0cf4732c762e4dbe8c21e12cf";
    hash = "sha256-5dowoFZn9I2IXMQ3Pz+2Eo3rKfihLzjca84MytQIXcU=";
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
    mainProgram = "udebugd";
    homepage = "https://git.openwrt.org/?p=project/udebug.git;a=summary";
    license = licenses.free;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mkg20001 ];
  };
}
