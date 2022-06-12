{ stdenv, lib, fetchgit, cmake, pkg-config, json_c }:

stdenv.mkDerivation {
  pname = "libubox";
  version = "unstable-2021-03-09";

  src = fetchgit {
    url = "https://git.openwrt.org/project/libubox.git";
    rev = "551d75b5662cccd0466b990d58136bdf799a804d";
    sha256 = "05cnjjqjv9nvrs1d8pg4xxxf27jryiv6xk8plmdpmm7r2wkvwn3r";
  };

  cmakeFlags = [ "-DBUILD_LUA=OFF" "-DBUILD_EXAMPLES=OFF" ];

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ json_c ];

  meta = with lib; {
    description = "C utility functions for OpenWrt";
    homepage = "https://git.openwrt.org/?p=project/libubox.git;a=summary";
    license = licenses.isc;
    maintainers = with maintainers; [ fpletz ];
    mainProgram = "jshn";
    platforms = platforms.all;
  };
}
