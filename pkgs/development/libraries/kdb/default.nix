{
  mkDerivation,
  lib,
  fetchFromGitLab,
  extra-cmake-modules,
  qtbase,
  kcoreaddons,
  python3,
  sqlite,
  libpq,
  libmysqlclient,
  qttools,
}:

mkDerivation {
  pname = "kdb";
  version = "3.2.0-unstable-2025-10-17";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "libraries";
    repo = "kdb";
    rev = "819f9f61d629ffd80990ae17ae6c8078721a142b";
    hash = "sha256-XkpFFzTgLEjPxEzwinbGhHRTULQrhl5TdakJlQuI27A=";
  };

  nativeBuildInputs = [
    extra-cmake-modules
    qttools
  ];

  buildInputs = [
    kcoreaddons
    python3
    sqlite
    libpq
    libmysqlclient
  ];

  propagatedBuildInputs = [ qtbase ];

  meta = {
    description = "Database connectivity and creation framework for various database vendors";
    mainProgram = "kdb3_sqlite3_dump";
    license = lib.licenses.lgpl2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ zraexy ];
  };
}
