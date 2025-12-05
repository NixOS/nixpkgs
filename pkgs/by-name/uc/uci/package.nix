{
  lib,
  stdenv,
  cmake,
  fetchgit,
  pkg-config,
  libubox,
}:

stdenv.mkDerivation {
  pname = "uci";
  version = "unstable-2025-10-12";

  src = fetchgit {
    url = "https://git.openwrt.org/project/uci.git";
    rev = "57c1e8cd2c051d755ca861a9ab38a8049d2e3f95";
    hash = "sha256-/Ian7WoBvm9nmniHdVTEIyRW1BPTmOe3O0v59aDaXc0=";
  };

  hardeningDisable = [ "all" ];
  cmakeFlags = [ "-DBUILD_LUA=OFF" ];
  buildInputs = [ libubox ];
  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  meta = with lib; {
    description = "OpenWrt Unified Configuration Interface";
    mainProgram = "uci";
    homepage = "https://git.openwrt.org/?p=project/uci.git;a=summary";
    license = licenses.lgpl21Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ mkg20001 ];
  };
}
