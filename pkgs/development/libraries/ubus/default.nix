{ stdenv, cmake, fetchgit, libubox, libjson }:

stdenv.mkDerivation {
  pname = "ubus";
  version = "unstable-2020-01-05";

  src = fetchgit {
    url = "https://git.openwrt.org/project/ubus.git";
    rev = "d35df8adda873dc75d876f72b78e84db8cfa72ee";
    sha256 = "1ksrih5vfyixaafzsrs6ab88qw34d0197wvw201jl5p1fc7drgn4";
  };

  cmakeFlags = [ "-D BUILD_LUA:BOOL=OFF" ];
  buildInputs = [ libubox libjson ];
  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "OpenWrt system message/RPC bus";
    homepage = "https://git.openwrt.org/?p=project/ubus.git;a=summary";
    license = licenses.lgpl21;
    platforms = platforms.all;
    maintainers = with maintainers; [ petabyteboy ];
  };
}
