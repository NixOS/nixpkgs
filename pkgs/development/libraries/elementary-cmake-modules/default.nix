{ stdenv, lib, fetchFromGitHub, cmake, pkgconfig }:

stdenv.mkDerivation {
  name = "elementary-cmake-modules";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "cmake-modules";
    rev = "319ec5336e9f05f3f22b886cc2053ef3d4b6599e";
    sha256 = "191hhvdxyqvh9axzndaqld7vrmv7xkn0czks908zhb2zpjhv9rby";
  };

  prePatch = ''
    substituteInPlace CMakeLists.txt  \
      --replace ' ''${CMAKE_ROOT}/Modules' " $out/lib/cmake"
  '';

  propagatedBuildInputs = [ cmake pkgconfig ];

  setupHook = ./setup-hook.sh;

  meta = with lib; {
    platforms = platforms.linux ++ platforms.darwin;
    homepage = https://github.com/elementary/cmake-modules;
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.samdroid-apps ];
  };
}
