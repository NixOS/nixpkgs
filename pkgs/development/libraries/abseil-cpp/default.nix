{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, static ? stdenv.hostPlatform.isStatic }:

stdenv.mkDerivation rec {
  pname = "abseil-cpp";
  version = "20210324.1";

  src = fetchFromGitHub {
    owner = "abseil";
    repo = "abseil-cpp";
    rev = version;
    sha256 = "16w63brfwgiayiyhvawsnr14xyy5hpp68k8fj0z6yk0bjzw6jvjw";
  };

  patches = [
    # Use CMAKE_INSTALL_FULL_{LIBDIR,INCLUDEDIR}
    # https://github.com/abseil/abseil-cpp/pull/963
    (fetchpatch {
      url = "https://github.com/abseil/abseil-cpp/commit/5bfa70c75e621c5d5ec095c8c4c0c050dcb2957e.patch";
      sha256 = "0nhjxqfxpi2pkfinnqvd5m4npf9l1kg39mjx9l3087ajhadaywl5";
    })
  ];

  cmakeFlags = [
    "-DCMAKE_CXX_STANDARD=17"
    "-DBUILD_SHARED_LIBS=${if static then "OFF" else "ON"}"
  ];

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "An open-source collection of C++ code designed to augment the C++ standard library";
    homepage = "https://abseil.io/";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = [ maintainers.andersk ];
  };
}
