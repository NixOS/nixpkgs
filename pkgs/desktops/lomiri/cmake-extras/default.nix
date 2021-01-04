{ stdenv, fetchFromGitHub, fetchurl
, cmake, pkg-config, gmock, lcov, gcovr, doxygen, graphviz
}:

let
  # https://github.com/ubports/cmake-extras/issues/2#issuecomment-450582679
  gtestCMake = fetchurl {
    url = "https://raw.githubusercontent.com/MirServer/mir/eecb7af2ebbdf915344f4d0b6b5dc31cce73b9f9/cmake/FindGtestGmock.cmake";
    sha256 = "1z8fplpfah071sdy1d9iikymirxrm340n4wbl54cr46s698487pj";
  };
in
stdenv.mkDerivation rec {
  pname = "cmake-extras-unstable";
  version = "2020-08-17";

  src = fetchFromGitHub {
    owner = "ubports";
    repo = "cmake-extras";
    rev = "f6b455df21fa483388a79db6366707310d68167e";
    sha256 = "1z601r7fbik1lzvgz78jcaj99yk2zncics7y7aw453hal33l8mxl";
  };

  postPatch = ''
    cp ${gtestCMake} src/GMock/GMockConfig.cmake
  '';

  nativeBuildInputs = [ cmake ];

  propagatedBuildInputs = [ pkg-config gmock lcov gcovr doxygen graphviz ];

  meta = with stdenv.lib; {
    description = "A collection of add-ons for the CMake build tool";
    homepage = "https://gitlab.com/ubports/core/cmake-extras";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.linux;
  };
}
