{ stdenv
, lib
, fetchgit
, cmake
, pkg-config
, libubox-nossl
, ssl_implementation
, additional_buildInputs ? [ ]
}:

stdenv.mkDerivation {
  pname = "ustream-ssl";
  version = "0-unstable-2024-03-26";

  src = fetchgit {
    url = "https://git.openwrt.org/project/ustream-ssl.git";
    rev = "7621339d7694abef5da5e5353ac440f2d39dcecb";
    hash = "sha256-No0Pk8KbkT7W4Rav7W3rMKEJISbp7RRoRx7t6LPMxlk=";
  };

  preConfigure = ''
    sed -r \
        -e "s|ubox_include_dir libubox/ustream.h|ubox_include_dir libubox/ustream.h HINTS ${libubox-nossl}/include|g" \
        -e "s|ubox_library NAMES ubox|ubox_library NAMES ubox HINTS ${libubox-nossl}/lib|g" \
        -e "s|^  FIND_LIBRARY\((.+)\)|  FIND_LIBRARY\(\1 HINTS ${if ssl_implementation ? lib then ssl_implementation.lib else ssl_implementation.out}\)|g" \
        -i CMakeLists.txt
  '';

  cmakeFlags = [ "-D${lib.toUpper ssl_implementation.pname}=ON" ];

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ ssl_implementation ] ++ additional_buildInputs;

  passthru = {
    inherit ssl_implementation;
  };

  meta = with lib; {
    description = "ustream SSL wrapper";
    homepage = "https://git.openwrt.org/?p=project/ustream-ssl.git;a=summary";
    license = licenses.isc;
    maintainers = with maintainers; [ fpletz mkg20001 ];
    platforms = platforms.all;
  };
}
