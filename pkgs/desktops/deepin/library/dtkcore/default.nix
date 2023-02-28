{ stdenv
, lib
, fetchFromGitHub
, pkg-config
, cmake
, gsettings-qt
, wrapQtAppsHook
, lshw
, dtkcommon
}:

stdenv.mkDerivation rec {
  pname = "dtkcore";
  version = "5.6.3";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "sha256-DEpo/eKMjtTVGEkq5JofkRNSHtTOZ1t2QNjrdulUtPQ=";
  };

  postPatch = ''
    substituteInPlace src/dsysinfo.cpp \
      --replace "/usr/share/deepin/distribution.info" "/etc/distribution.info" \
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    gsettings-qt
    lshw
  ];

  propagatedBuildInputs = [ dtkcommon ];

  cmakeFlags = [
    "-DDVERSION=${version}"
    "-DBUILD_DOCS=OFF"
    "-DDSG_PREFIX_PATH='/run/current-system/sw'"
    "-DMKSPECS_INSTALL_DIR=${placeholder "out"}/mkspecs/modules"
  ];

  meta = with lib; {
    description = "Deepin tool kit core library";
    homepage = "https://github.com/linuxdeepin/dtkcore";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
