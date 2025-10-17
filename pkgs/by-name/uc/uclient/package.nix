{
  stdenv,
  lib,
  fetchgit,
  cmake,
  pkg-config,
  libubox,
  ucode,
  json_c,
}:

stdenv.mkDerivation {
  pname = "uclient";
  version = "unstable-2025-10-03";

  src = fetchgit {
    url = "https://git.openwrt.org/project/uclient.git";
    rev = "dc909ca71bc884c0e5362e1d7cc7808696cb2add";
    hash = "sha256-jrhLBB3Mb7FvxMtKxG7e7D/hcyygTjx868POGtF+Dcc=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    libubox
    ucode
    json_c
  ];

  preConfigure = ''
    sed -e 's|ubox_include_dir libubox/ustream-ssl.h|ubox_include_dir libubox/ustream-ssl.h HINTS ${libubox}/include|g' \
        -e 's|ubox_library NAMES ubox|ubox_library NAMES ubox HINTS ${libubox}/lib|g' \
        -i CMakeLists.txt
  '';

  meta = with lib; {
    description = "Tiny OpenWrt fork of libnl";
    homepage = "https://git.openwrt.org/?p=project/uclient.git;a=summary";
    license = licenses.isc;
    maintainers = with maintainers; [ mkg20001 ];
    mainProgram = "uclient-fetch";
    platforms = platforms.all;
    broken = stdenv.hostPlatform.isDarwin;
  };
}
