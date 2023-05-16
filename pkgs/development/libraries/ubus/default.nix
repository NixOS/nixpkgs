{ lib, stdenv, cmake, fetchgit, libubox, libjson }:

stdenv.mkDerivation {
  pname = "ubus";
<<<<<<< HEAD
  version = "unstable-2023-06-05";

  src = fetchgit {
    url = "https://git.openwrt.org/project/ubus.git";
    rev = "f787c97b34894a38b15599886cacbca01271684f";
    hash = "sha256-PGPFtNaRXS6ryC+MA/w2CtPQfJa+vG5OXf/NPFMoIzQ=";
=======
  version = "unstable-2021-02-15";

  src = fetchgit {
    url = "https://git.openwrt.org/project/ubus.git";
    rev = "2537be01858710e714c329153760c64fe3f8a73e";
    sha256 = "03ljxsn4w87bfrilccxhrkzqmd30hy6ihkvsinw0i3l7rpp5m4a7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
