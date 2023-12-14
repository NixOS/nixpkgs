{ stdenvNoCC
, lib
, fetchFromGitHub
, gettext
, python3
}:

stdenvNoCC.mkDerivation rec {
  pname = "folder-color-switcher";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    # They don't really do tags, this is just a named commit.
    rev = "826df0b71c7c3b686421437eac86883945dc5956";
    sha256 = "sha256-WdOTyladZ0U39wbhqsXzg9l3mJ5UGV99yVg1PWscP2w=";
  };

  nativeBuildInputs = [
    gettext
    python3.pkgs.wrapPython
  ];

  postPatch = ''
    substituteInPlace usr/share/nemo-python/extensions/nemo-folder-color-switcher.py \
      --replace "/usr/share/locale" "$out/share" \
      --replace "/usr/share/folder-color-switcher/colors.d" "/run/current-system/sw/share/folder-color-switcher/colors.d" \
      --replace "/usr/share/folder-color-switcher/color.svg" "$out/share/folder-color-switcher/color.svg"

    substituteInPlace usr/share/caja-python/extensions/caja-folder-color-switcher.py \
      --replace "/usr/share/folder-color-switcher/colors.d" "/run/current-system/sw/share/folder-color-switcher/colors.d"
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    mv usr/share $out

    runHook postInstall
  '';

  preFixup = ''
    # For Gdk.cairo_surface_create_from_pixbuf()
    # TypeError: Couldn't find foreign struct converter for 'cairo.Surface'
    buildPythonPath ${python3.pkgs.pycairo}
    patchPythonScript $out/share/nemo-python/extensions/nemo-folder-color-switcher.py
  '';

  meta = with lib; {
    homepage = "https://github.com/linuxmint/folder-color-switcher";
    description = "Change folder colors for Nemo and Caja";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
}
