{ stdenv, lib, fetchgit, cmake, pkg-config, libubox }:

stdenv.mkDerivation {
  pname = "uclient";
  version = "unstable-2022-02-24";

  src = fetchgit {
    url = "https://git.openwrt.org/project/uclient.git";
    rev = "644d3c7e13c6a64bf5cb628137ee5bd4dada4b74";
    sha256 = "0vy4whs64699whp92d1zl7a8kh16yrfywqq0yp2y809l9z19sw22";
  };

  nativeBuildInputs = [ cmake pkg-config ];
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
  };
}
