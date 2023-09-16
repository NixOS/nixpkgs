{ stdenv
, lib
, fetchFromGitLab
, meson
, ninja
, pkg-config
, glib
, unstableGitUpdater
}:

stdenv.mkDerivation rec {
  pname = "gettext-pseudolocale";
  version = "0-unstable-2023-03-15";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "hadess";
    repo = "gettext-pseudolocale";
    rev = "2dc0491ea2ac016b8e8b746782595e56ae0c071b";
    hash = "sha256-+uL8VjNjWCpt9i3SQ0FuMe160sAtSUQHT2IRxSIq0z4=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    glib
  ];

  doCheck = true;

  passthru = {
    updateScript = unstableGitUpdater { };
  };

  meta = with lib; {
    description = "LD_PRELOAD library that hooks into gettext to highlight i18n bugs";
    homepage = "https://gitlab.freedesktop.org/hadess/gettext-pseudolocale";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jtojnar ];
  };
}
