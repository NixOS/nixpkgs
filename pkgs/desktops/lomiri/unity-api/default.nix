{ mkDerivation, lib, fetchFromGitHub
, cmake, cmake-extras, libqtdbustest, qtbase, qtquickcontrols2
, glib
}:

mkDerivation rec {
  pname = "unity-api-unstable";
  version = "2020-10-16";

  src = fetchFromGitHub {
    owner = "ubports";
    repo = "unity-api";
    # current branch to follow is "xenial_-_qt-5-12"
    rev = "d297a7602bb35ff28629022a570b41d40e06be8f";
    sha256 = "02mqylhmkmph5bs0szk0sfa12lksn16czvv5x9989ga07ak5rzbb";
  };

  postPatch = ''
    substituteInPlace data/libunity-api.pc.in \
      --replace '@CMAKE_INSTALL_LIBDIR@' 'lib'
    substituteInPlace CMakeLists.txt \
      --replace 'SHELL_PLUGINDIR ''\${CMAKE_INSTALL_LIBDIR}' 'SHELL_PLUGINDIR lib'
  '';

  nativeBuildInputs = [ cmake cmake-extras libqtdbustest qtbase qtquickcontrols2 ];

  buildInputs = [ glib ];

  outputs = [ "out" "dev" "doc" ];

  meta = with lib; {
    description = "API for Unity shell integration";
    homepage = "https://github.com/ubports/unity-api";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.linux;
  };
}
