{ lib, stdenv, fetchFromGitHub, cmake, clipper, nlopt, boost, conan }:

let withConanCMakeDeps = conan.withConanCMakeDepsFile;
in
stdenv.mkDerivation rec {
  version = "5.1.0";
  pname = "libnest2d";

  # This revision is waiting to be merged upstream
  # Once it has been merged, this should be switched to it
  # Upstream PR: https://github.com/tamasmeszaros/libnest2d/pull/18
  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "libnest2d";
    rev = version;
    hash = "sha256-m/ekKwkf4886tqOVIcNnUeBQtWreGFO/nx25usbAnDk=";
  };

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DLIBNEST2D_HEADER_ONLY=OFF"
  ];

  propagatedBuildInputs = [
    (withConanCMakeDeps {package = clipper; pkg_name = "clipper"; lib_search="polyclipping";})
    nlopt boost
  ];
  nativeBuildInputs = [ cmake ];

  CLIPPER_PATH = "${clipper.out}";

  postPatch = ''
  echo '
  install(TARGETS libnest2d libnest2d_headeronly ''${LIBNAME}
  EXPORT ''${PROJECT_NAME}Targets
  RUNTIME DESTINATION bin
  ARCHIVE DESTINATION lib
  LIBRARY DESTINATION lib
  INCLUDES DESTINATION include)
  ' >> CMakeLists.txt;
  '';

  postInstall = ''
  cp -r ../include/ $out/
  mkdir -p $out/include/libnest2d/
  exists() {
      [ -e "$1" ]
  }
  ls -R .
  for dir in . ..; do
    if exists $dir/src/*.{h,hpp}; then
      cp $dir/src/*.{h,hpp} $out/include/libnest2d/
    fi
  done
  '';

  meta = with lib; {
    description =
      "2D irregular bin packaging and nesting library written in modern C++";
    homepage = "https://github.com/Ultimaker/libnest2d";
    license = licenses.lgpl3;
    platforms = platforms.all;
  };
}
