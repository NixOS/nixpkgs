{ stdenv, cmake, fetchgit, pkgconfig, libubox }:

stdenv.mkDerivation {
  pname = "uci";
  version = "unstable-2020-04-27";

  src = fetchgit {
    url = "https://git.openwrt.org/project/uci.git";
    rev = "ec8d3233948603485e1b97384113fac9f1bab5d6";
    sha256 = "0p765l8znvwhzhgkq7dp36w62k5rmzav59vgdqmqq1bjmlz1yyi6";
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
