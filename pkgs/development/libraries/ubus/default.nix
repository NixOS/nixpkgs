{ lib, stdenv, cmake, fetchgit, libubox, libjson }:

stdenv.mkDerivation {
  pname = "ubus";
  version = "unstable-2023-11-14";

  src = fetchgit {
    url = "https://git.openwrt.org/project/ubus.git";
    rev = "b3e8c4ef07ebb6f0f34a5c1f0dc1539068363619";
    hash = "sha256-H/QrLMhdEC1LnSxHpp/90OdKbfHRqLVWUnzyQlsVO8c=";
  };

  cmakeFlags = [ "-DBUILD_LUA=OFF" ];
  buildInputs = [ libubox libjson ];
  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "OpenWrt system message/RPC bus";
    homepage = "https://git.openwrt.org/?p=project/ubus.git;a=summary";
    license = licenses.lgpl21Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ mkg20001 ];
  };
}
