{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, static ? stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation rec {
  pname = "abseil-cpp";
  version = "20210324.2";

  src = fetchFromGitHub {
    owner = "abseil";
    repo = "abseil-cpp";
    rev = version;
    sha256 = "sha256-rLEd0HYWfPIDIhZbsBDqG8lads6kKaTMVJEEegPOz+o=";
    # Make sure to use the provided implementations of C++17 types.
    # Without this setting libraries compiled with different C++ standards
    # will not be ABI compatible.
    # Done here because the src attribute is reused in tensorflow-lite and
    # dragonflydb.
    postFetch = ''
      substituteInPlace $out/absl/base/options.h \
        --replace "ABSL_OPTION_USE_STD_ANY 2" "ABSL_OPTION_USE_STD_ANY 0" \
        --replace "ABSL_OPTION_USE_STD_OPTIONAL 2" "ABSL_OPTION_USE_STD_OPTIONAL 0" \
        --replace "ABSL_OPTION_USE_STD_STRING_VIEW 2" "ABSL_OPTION_USE_STD_STRING_VIEW 0" \
        --replace "ABSL_OPTION_USE_STD_VARIANT 2" "ABSL_OPTION_USE_STD_VARIANT 0"
    '';
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
    "-DBUILD_SHARED_LIBS=${if static then "OFF" else "ON"}"
    "-DABSL_PROPAGATE_CXX_STD=ON"
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
