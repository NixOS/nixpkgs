{ stdenv, lib, fetchgit, cmake, pkgconfig, json_c }:

stdenv.mkDerivation {
  pname = "libubox";
  version = "unstable-2020-01-20";

  src = fetchgit {
    url = "https://git.openwrt.org/project/libubox.git";
    rev = "43a103ff17ee5872669f8712606578c90c14591d";
    sha256 = "0cihgckghamcfxrvqjjn69giib80xhsqaj98ldn0gd96zqh96sd4";
  };

  cmakeFlags = [ "-DBUILD_LUA=OFF" "-DBUILD_EXAMPLES=OFF" ];

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ json_c ];

  meta = with lib; {
    description = "C utility functions for OpenWrt";
    homepage = "https://git.openwrt.org/?p=project/libubox.git;a=summary";
    license = licenses.isc;
    platforms = platforms.all;
    maintainers = with maintainers; [ fpletz ];
  };
}
