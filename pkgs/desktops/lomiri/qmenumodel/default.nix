{ mkDerivation, fetchFromGitHub
, cmake, cmake-extras, pkg-config, dbus-test-runner
, qtbase, qtdeclarative, qtquickcontrols2
}:

mkDerivation rec {
  pname = "qmenumodel-unstable";
  version = "2018-07-27";

  src = fetchFromGitHub {
    owner = "ubports";
    repo = "qmenumodel";
    # branch to follow should be "xenial_-_qt-5-12" (I think?), but required commit is only in master
    rev = "30e3dc541966abfd2ac1436caec7cd4bebdf996e";
    sha256 = "1zzsh3k9g4z7l3043rr2cnlmvd854n2cafhm6gz4a8lj2jwn0kwg";
  };

  patches = [ ./0001-Fix_CMake_Qt5_in_tests.patch ];

  postPatch = ''
    substituteInPlace libqmenumodel/src/qmenumodel.pc.in \
      --replace '@CMAKE_INSTALL_LIBDIR@' 'lib' \
      --replace '@CMAKE_INSTALL_INCLUDEDIR@' 'include'
  '';

  nativeBuildInputs = [ cmake cmake-extras dbus-test-runner ];

  buildInputs = [ qtbase qtdeclarative qtquickcontrols2 ];
}
