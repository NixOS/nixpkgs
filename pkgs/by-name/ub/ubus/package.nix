{
  lib,
  stdenv,
  cmake,
  fetchgit,
  libubox,
  libjson,
}:

stdenv.mkDerivation {
  pname = "ubus";
  version = "unstable-202-10-17";

  src = fetchgit {
    url = "https://git.openwrt.org/project/ubus.git";
    rev = "60e04048a0e2f3e33651c19e62861b41be4c290f";
    hash = "sha256-fjxO77z+do5gZ7nLwHbC14UnP9cmZ5eANNn4X6Sudn0=";
  };

  cmakeFlags = [ "-DBUILD_LUA=OFF" ];
  buildInputs = [
    libubox
    libjson
  ];
  nativeBuildInputs = [ cmake ];

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
      "-Wno-error=gnu-folding-constant"
    ]
  );

  meta = with lib; {
    description = "OpenWrt system message/RPC bus";
    homepage = "https://git.openwrt.org/?p=project/ubus.git;a=summary";
    license = licenses.lgpl21Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ mkg20001 ];
  };
}
