{ stdenv, lib, fetchgit, cmake, pkgconfig, json_c }:

stdenv.mkDerivation {
  name = "libubox-2017-09-29";

  src = fetchgit {
    url = "https://git.openwrt.org/project/libubox.git";
    rev = "632688e8d6cde32781e4ec685d59afb0938300ad";
    sha256 = "1rkwn287k7p802hbd9ap13xxrxsghq6827r86ymqbbcmbcrna13c";
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
