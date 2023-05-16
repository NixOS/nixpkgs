{ lib, stdenv, cmake, fetchgit, pkg-config, libubox }:

stdenv.mkDerivation {
  pname = "uci";
<<<<<<< HEAD
  version = "unstable-2023-08-10";

  src = fetchgit {
    url = "https://git.openwrt.org/project/uci.git";
    rev = "5781664d5087ccc4b5ab58505883231212dbedbc";
    hash = "sha256-8MyFaZdAMh5oMPO/5QyNT+Or57eBL3mamJLblGGoF9g=";
=======
  version = "unstable-2021-04-14";

  src = fetchgit {
    url = "https://git.openwrt.org/project/uci.git";
    rev = "4b3db1179747b6a6779029407984bacef851325c";
    sha256 = "1zflxazazzkrycpflzfg420kzp7kgy4dlz85cms279vk07dc1d52";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  hardeningDisable = [ "all" ];
  cmakeFlags = [ "-DBUILD_LUA=OFF" ];
  buildInputs = [ libubox ];
  nativeBuildInputs = [ cmake pkg-config ];

  meta = with lib; {
    description = "OpenWrt Unified Configuration Interface";
    homepage = "https://git.openwrt.org/?p=project/uci.git;a=summary";
    license = licenses.lgpl21Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ ];
  };
}
