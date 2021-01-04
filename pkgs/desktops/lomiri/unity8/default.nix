{ mkDerivation, lib, fetchFromGitHub, fetchpatch
, cmake, cmake-extras
, unity-api, geonames, qmenumodel, ubuntu-app-launch, gnome3, gtk3, mir_1, qtbase, ubuntu-ui-toolkit, libqtdbustest, libqtdbusmock, system-settings, indicator-network, gsettings-qt, deviceinfo, dbus-test-runner, libusermetrics, lightdm_qt, xvfb_run, ubuntu-download-manager, libevdev, qtquickcontrols2, pam, properties-cpp
}:

mkDerivation rec {
  pname = "unity8-unstable";
  version = "2020-11-30";

  src = fetchFromGitHub {
    owner = "ubports";
    repo = "unity8";
    rev = "39876885449df890f936edcb5b7bc6a63e80f0a0";
    sha256 = "1441bbyh5v38qkjm1f9dyhx7dbcrjn48b0wsggpnvfzkl5h9hdrf";
  };

  patches = [
    (fetchpatch {
      url = "https://gitlab.manjaro.org/manjaro-arm/packages/community/lomiri-dev/unity8-git/-/raw/ce604e26acb1afc28fcea9748b107ebb2f568364/NoDpkgParse.patch";
      sha256 = "15brdgj8cm70yhjby9p0c10flnvzhvwp5mvfdgmjdkv7zkvlg7b4";
    })
  ];

  postPatch = ''
    patchShebangs .
    substituteInPlace CMakeLists.txt \
      --replace 'ubuntu-app-launch-2' 'ubuntu-app-launch-3'
    substituteInPlace tests/uqmlscene/CMakeLists.txt \
      --replace 'set_target_properties(uqmlscene PROPERTIES INCLUDE_DIRECTORIES $''\{XCB_INCLUDE_DIRS})' \
        'include_directories($''\{XCB_INCLUDE_DIRS})'
  '';

  nativeBuildInputs = [ cmake cmake-extras ];

  buildInputs = [ unity-api geonames qmenumodel ubuntu-app-launch gnome3.gnome-desktop gtk3 mir_1 ubuntu-ui-toolkit libqtdbustest libqtdbusmock qtbase system-settings indicator-network gsettings-qt deviceinfo dbus-test-runner libusermetrics lightdm_qt xvfb_run ubuntu-download-manager libevdev qtquickcontrols2 pam properties-cpp ];

  meta = with lib; {
    description = "A convergent desktop environment.";
    longDescription = ''
      A convergent desktop environment. Now called Lomiri, but still developed in
      this repository.
    '';
    homepage = "https://unity8.io/";
    license = with licenses; [ gpl3Only lgpl21Only ];
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.linux;
  };
}
