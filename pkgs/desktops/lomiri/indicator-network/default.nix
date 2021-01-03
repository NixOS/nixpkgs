{ mkDerivation, lib, fetchFromGitHub
, cmake, cmake-extras, intltool
, qtbase, unity-api, ofono, networkmanager, libsecret, url-dispatcher, gsettings-qt, libqofono, libqtdbustest, libqtdbusmock, gmenuharness
}:

mkDerivation rec {
  pname = "indicator-network-unstable";
  version = "2019-09-07";

  src = fetchFromGitHub {
    owner = "ubports";
    repo = "indicator-network";
    rev = "2539978c51684822733fbbd7ebb6971d671492a0";
    sha256 = "18dm2mwki5827b369mj1yrdpcmw1x97mhg8f94hgivjyvx793sa8";
  };

  postPatch = ''
    substituteInPlace data/CMakeLists.txt \
      --replace "/usr" "$out"
  '';

  nativeBuildInputs = [ cmake cmake-extras intltool ];

  buildInputs = [ qtbase unity-api ofono networkmanager libsecret url-dispatcher gsettings-qt libqofono libqtdbustest libqtdbusmock gmenuharness ];

  cmakeFlags = [ "-DGSETTINGS_LOCALINSTALL=ON" ];

  meta = with lib; {
    description = "Systems settings menu service - Network indicator";
    longDescription = ''
      The Indicator-network service is responsible for exporting the system settings
      menu through dbus.
      Includes the Ubuntu Connectivity API.
    '';
    homepage = "https://launchpad.net/indicator-network";
    license = with licenses; [ gpl3Only lgpl3Only ];
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.linux;
  };
}
