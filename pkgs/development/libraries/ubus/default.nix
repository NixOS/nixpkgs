{ lib, stdenv, cmake, fetchgit, libubox, libjson }:

stdenv.mkDerivation {
  pname = "ubus";
  version = "unstable-2023-06-05";

  src = fetchgit {
    url = "https://git.openwrt.org/project/ubus.git";
    rev = "f787c97b34894a38b15599886cacbca01271684f";
    hash = "sha256-PGPFtNaRXS6ryC+MA/w2CtPQfJa+vG5OXf/NPFMoIzQ=";
  };

  cmakeFlags = [ "-DBUILD_LUA=OFF" ];
  buildInputs = [ libubox libjson ];
  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "OpenWrt system message/RPC bus";
    homepage = "https://git.openwrt.org/?p=project/ubus.git;a=summary";
    license = licenses.lgpl21Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ ];
  };
}
