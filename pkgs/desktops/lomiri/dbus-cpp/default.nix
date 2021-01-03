{ stdenv, fetchFromGitHub, fetchpatch
, cmake, cmake-extras, lsb-release, properties-cpp
, boost, libxml2, dbus, process-cpp
}:

stdenv.mkDerivation rec {
  pname = "dbus-cpp-unstable";
  version = "2018-04-09";

  src = fetchFromGitHub {
    owner = "lib-cpp";
    repo = "dbus-cpp";
    rev = "967dc1caf0efe0a1286c308e8e8dd1bf7da5f3ee";
    sha256 = "17n7gnqc6zlcjj80rk982rnpn4q1jck99mlj263n45psxq78hq23";
  };

  patches = [
    (fetchpatch {
      name = "dbus-cpp-Fix_build_with_newer_Boost.patch";
      url = "https://github.com/lib-cpp/dbus-cpp/pull/2/commits/0cec0d810b5762d943c113aa27677a625661e189.patch";
      sha256 = "15b3g3lbgydygvdnq3c2bydybp35azmn3dgp0f6silg27am50s8j";
    })
  ];

  nativeBuildInputs = [ cmake lsb-release cmake-extras properties-cpp ];

  buildInputs = [ boost libxml2 dbus process-cpp ];

  cmakeFlags = [
    "-DCMAKE_CXX_FLAGS=-Wno-error=deprecated-copy"
  ];

  meta = with stdenv.lib; {
    description = "Header-only dbus-binding leveraging C++-11";
    longDescription = ''
      A header-only dbus-binding leveraging C++-11, relying on compile-time
      polymorphism to integrate with arbitrary type systems.
    '';
    # CMake files are GPL2+, everything else LGPL3
    license = with licenses; [ lgpl3Only gpl2Plus ];
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.linux;
  };
}
