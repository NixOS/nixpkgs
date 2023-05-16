{ stdenv, lib, fetchgit, cmake, pkg-config, libubox-nossl, ssl_implementation }:

stdenv.mkDerivation {
  pname = "ustream-ssl";
<<<<<<< HEAD
  version = "unstable-2023-02-25";

  src = fetchgit {
    url = "https://git.openwrt.org/project/ustream-ssl.git";
    rev = "498f6e268d4d2b0ad33b430f4ba1abe397d31496";
    hash = "sha256-qwF3pzJ/nUTaJ8NZtgLyXnSozekY3dovxK3ZWHPGORM=";
=======
  version = "unstable-2022-12-08-${ssl_implementation.pname}";

  src = fetchgit {
    url = "https://git.openwrt.org/project/ustream-ssl.git";
    rev = "9217ab46536353c7c792951b57163063f5ec7a3b";
    sha256 = "1ldyyb3is213iljyccx98f56rb69rfpgdcb1kjxw9a176hvpipdd";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
  buildInputs = [ ssl_implementation ];

  passthru = {
    inherit ssl_implementation;
  };

  meta = with lib; {
    description = "ustream SSL wrapper";
    homepage = "https://git.openwrt.org/?p=project/ustream-ssl.git;a=summary";
    license = licenses.isc;
    maintainers = with maintainers; [ fpletz ];
    platforms = platforms.all;
  };
}
