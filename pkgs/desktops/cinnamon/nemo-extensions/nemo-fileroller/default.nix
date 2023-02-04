{ stdenv
, lib
, fetchFromGitHub
, meson
, pkg-config
, ninja
, glib
, gtk3
, nemo
, gnome
}:

stdenv.mkDerivation rec {
  pname = "nemo-fileroller";
  version = "5.6.1";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "nemo-extensions";
    rev = "nemo-fileroller-${version}";
    sha256 = "sha256-dPmAHuJ0ZRTAwhnMMZEu1e9+qZRYCnlaaoCdUP45W+s=";
  };

  sourceRoot = "${src.name}/nemo-fileroller";

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
  ];

  buildInputs = [
    glib
    gtk3
    nemo
  ];

  postPatch = ''
    substituteInPlace src/nemo-fileroller.c \
      --replace "file-roller" "${lib.getExe gnome.file-roller}"
  '';

  PKG_CONFIG_LIBNEMO_EXTENSION_EXTENSIONDIR = "${placeholder "out"}/${nemo.extensiondir}";

  meta = with lib; {
    homepage = "https://github.com/linuxmint/nemo-extensions/tree/master/nemo-fileroller";
    description = "Nemo file roller extension";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
}
