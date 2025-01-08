{
  stdenv,
  lib,
  fetchgit,
  cmake,
  pkg-config,
  libubox,
}:

stdenv.mkDerivation {
  pname = "uclient";
  version = "unstable-2023-04-13";

  src = fetchgit {
    url = "https://git.openwrt.org/project/uclient.git";
    rev = "007d945467499f43656b141171d31f5643b83a6c";
    hash = "sha256-A47dyVc2MtOL6aImZ0b3SMWH2vzjfAXzRAOF4nfH6S0=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buidInputs = [ libubox ];

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
