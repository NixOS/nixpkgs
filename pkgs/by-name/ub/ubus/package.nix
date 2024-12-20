{ lib, stdenv, cmake, fetchgit, libubox, libjson }:

stdenv.mkDerivation {
  pname = "ubus";
  version = "unstable-2023-12-18";

  src = fetchgit {
    url = "https://git.openwrt.org/project/ubus.git";
    rev = "65bb027054def3b94a977229fd6ad62ddd32345b";
    hash = "sha256-n82Ub0IiuvWbnlDCoN+0hjo/1PbplEbc56kuOYMrHxQ=";
  };

  cmakeFlags = [ "-DBUILD_LUA=OFF" ];
  buildInputs = [ libubox libjson ];
  nativeBuildInputs = [ cmake ];

  env.NIX_CFLAGS_COMPILE = toString (lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
    "-Wno-error=gnu-folding-constant"
  ]);

  meta = with lib; {
    description = "OpenWrt system message/RPC bus";
    homepage = "https://git.openwrt.org/?p=project/ubus.git;a=summary";
    license = licenses.lgpl21Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ mkg20001 ];
  };
}
