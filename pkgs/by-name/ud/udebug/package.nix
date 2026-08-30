{
  lib,
  stdenv,
  cmake,
  fetchgit,
  pkg-config,
  ubus,
  libubox,
  ucode,
  json_c,
}:

stdenv.mkDerivation {
  pname = "udebug";
  version = "unstable-2025-09-28";

  src = fetchgit {
    url = "https://git.openwrt.org/project/udebug.git";
    rev = "5327524e715332daaebf6b04c155d2880d230979";
    hash = "sha256-Zcbbo7Jo7JxNSjUlbB2m2Id8crdxzKc/QFeduPGvows=";
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

  meta = {
    description = "OpenWrt debugging helper library/service";
    mainProgram = "udebugd";
    homepage = "https://git.openwrt.org/?p=project/udebug.git;a=summary";
    license = lib.licenses.free;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ mkg20001 ];
  };
}
