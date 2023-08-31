{ stdenv
, lib
, fetchFromGitLab
, fetchpatch
, meson
, ninja
, pkg-config
, gettext
, itstool
, libxml2
, glib
, shared-mime-info
}:

stdenv.mkDerivation rec {
  pname = "shared-mime-info";
  version = "2.2-37-g9b8ad99";

  outputs = [ "out" "dev" ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "xdg";
    repo = pname;
    rev = "9b8ad99a33973e5ed70ad698f9a89f5779e19f16";
    sha256 = "sha256-9nl68gLn+IdBIeUebgCaJ1ZH9RwTnK/xLCRwJJAhXYk=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    libxml2
  ] ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) shared-mime-info;

  buildInputs = [
    libxml2
    glib
  ];

  strictDeps = true;

  mesonFlags = [
    "-Dupdate-mimedb=true"
  ];

  meta = with lib; {
    description = "A database of common MIME types";
    homepage = "http://freedesktop.org/wiki/Software/shared-mime-info";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = teams.freedesktop.members ++ [ maintainers.mimame ];
    mainProgram = "update-mime-database";
  };
}
