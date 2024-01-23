{ lib, stdenv, cmake, fetchgit, libubox, libjson }:

stdenv.mkDerivation {
  pname = "ubus";
  version = "unstable-2023-11-28";

  src = fetchgit {
    url = "https://git.openwrt.org/project/ubus.git";
    rev = "f84eb5998c6ea2d34989ca2d3254e56c66139313";
    hash = "sha256-5pIovqIeJczWAA9KQPKFnTnGRrIZVdSNdxBR8AEFtO4=";
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
