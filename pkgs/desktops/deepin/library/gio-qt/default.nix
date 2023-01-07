{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, wrapQtAppsHook
, glibmm
, doxygen
, buildDocs ? false
}:

stdenv.mkDerivation rec {
  pname = "gio-qt";
  version = "0.0.11";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "sha256-dlY1CTlXywgGZUonBBe3cDwx8h2xXrPY6Ft/D59nlug=";
  };

  nativeBuildInputs = [ cmake pkg-config wrapQtAppsHook ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DPROJECT_VERSION=${version}"
  ]
  ++ lib.optional (!buildDocs) [ "-DBUILD_DOCS=OFF" ];

  buildInputs = lib.optional buildDocs doxygen;

  propagatedBuildInputs = [ glibmm ];

  meta = with lib; {
    description = "Gio wrapper for Qt applications";
    homepage = "https://github.com/linuxdeepin/gio-qt";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
