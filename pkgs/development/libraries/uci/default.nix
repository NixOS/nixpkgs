{ stdenv, cmake, fetchgit, pkgconfig, libubox }:

stdenv.mkDerivation {
  pname = "uci";
  version = "unstable-2020-01-27";

  src = fetchgit {
    url = "https://git.openwrt.org/project/uci.git";
    rev = "e8d83732f9eb571dce71aa915ff38a072579610b";
    sha256 = "1si8dh8zzw4j6m7387qciw2akfvl7c4779s8q5ns2ys6dn4sz6by";
  };

  hardeningDisable = [ "all" ];
  cmakeFlags = [ "-D BUILD_LUA:BOOL=OFF" ];
  buildInputs = [ libubox ];
  nativeBuildInputs = [ cmake pkgconfig ];

  meta = with stdenv.lib; {
    description = "OpenWrt Unified Configuration Interface";
    homepage = "https://git.openwrt.org/?p=project/uci.git;a=summary";
    license = licenses.lgpl21;
    platforms = platforms.all;
    maintainers = with maintainers; [ petabyteboy ];
  };
}
