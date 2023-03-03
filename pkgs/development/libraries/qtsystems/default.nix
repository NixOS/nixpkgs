{ mkDerivation
, stdenv
, lib
, fetchFromGitHub
, fetchpatch
, bluez
, dbus
, libevdev
, libX11
, perl
, pkg-config
, qmake
, qtbase
, qtdeclarative
, udev
# No examples available on Darwin
, withExamples ? (!stdenv.hostPlatform.isDarwin)
}:

mkDerivation rec {
  pname = "qtsystems";
  version = "unstable-2019-01-03";

  src = fetchFromGitHub {
    owner = "qt";
    repo = "qtsystems";
    rev = "e3332ee38d27a134cef6621fdaf36687af1b6f4a";
    hash = "sha256-P8MJgWiDDBCYo+icbNva0LODy0W+bmQTS87ggacuMP0=";
  };

  outputs = [
    "out"
    "dev"
  ];

  patches = [
    # Enable building with udisks support
    (fetchpatch {
      url = "https://salsa.debian.org/qt-kde-team/qt/qtsystems/-/raw/a23fd92222c33479d7f3b59e48116def6b46894c/debian/patches/2001_build_with_udisk.patch";
      hash = "sha256-B/z/+tai01RU/bAJSCp5a0/dGI8g36nwso8MiJv27YM=";
    })
  ];

  postPatch = ''
    substituteInPlace src/tools/{servicefw,sfwlisten}/*.pro \
      --replace '$$[QT_INSTALL_BINS]' "$dev/bin/"
    substituteInPlace $(find examples -name '*.pro') \
      --replace '$$[QT_INSTALL_EXAMPLES]' "$dev/share/examples"
  '';

  strictDeps = true;

  nativeBuildInputs = [
    perl
    pkg-config
    qmake
  ];

  buildInputs = [
    qtbase
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    bluez
    libevdev
    libX11
    udev
  ] ++ lib.optionals withExamples [
    qtdeclarative
  ];

  nativeCheckInputs = [
    dbus
  ];

  qmakeFlags = [
    "CONFIG+=git_build"
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    "CONFIG+=ofono"
    "CONFIG+=udisks"
    "CONFIG+=upower"
  ] ++ lib.optionals withExamples [
    "QT_BUILD_PARTS+=examples"
  ] ++ lib.optionals doCheck [
    "CONFIG+=tests"
    "QT_BUILD_PARTS+=tests"
  ];

  dontWrapQtApps = true;

  # No test cases available on Darwin
  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform && !stdenv.hostPlatform.isDarwin;

  checkPhase = ''
    runHook preCheck

    export HOME=$PWD
    export XDG_DATA_HOME=$PWD/.local/share
    export LD_LIBRARY_PATH=$PWD/lib
    dbus-run-session --config-file=${dbus}/share/dbus-1/session.conf -- make check -C tests

    runHook postCheck
  '';

  postFixup = lib.optionalString withExamples ''
    for example in $(find $dev/share/examples -type f -executable); do
      wrapQtApp $example
    done
  '';

  meta = with lib; {
    description = "Qt Systems";
    homepage = "https://github.com/qt/qtsystems";
    license = with licenses; [ lgpl3Only /* or */ gpl2Plus ];
    platforms = platforms.all;
    maintainers = with maintainers; [ OPNA2608 ];
  };
}
