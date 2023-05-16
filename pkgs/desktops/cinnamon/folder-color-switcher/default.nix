{ stdenvNoCC
, lib
, fetchFromGitHub
, gettext
<<<<<<< HEAD
, python3
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenvNoCC.mkDerivation rec {
  pname = "folder-color-switcher";
<<<<<<< HEAD
  version = "1.5.9";
=======
  version = "1.5.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    # They don't really do tags, this is just a named commit.
<<<<<<< HEAD
    rev = "b735ed90b798eda541885735368930d045430e6e";
    sha256 = "sha256-acbBghi3LWpGH1dBF8icuTGgliA+NM+pE8YDN3WxOic=";
=======
    rev = "5e0b768b3a5bf88a828a2489b9428997b797c1ed";
    sha256 = "sha256-DU75LM5v2/E/ZmqQgyiPsOOEUw9QQ/NXNtGDFzzYvyY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    gettext
<<<<<<< HEAD
    python3.pkgs.wrapPython
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  postPatch = ''
    substituteInPlace usr/share/nemo-python/extensions/nemo-folder-color-switcher.py \
<<<<<<< HEAD
      --replace "/usr/share/locale" "$out/share" \
      --replace "/usr/share/folder-color-switcher/colors.d" "/run/current-system/sw/share/folder-color-switcher/colors.d" \
      --replace "/usr/share/folder-color-switcher/color.svg" "$out/share/folder-color-switcher/color.svg"

    substituteInPlace usr/share/caja-python/extensions/caja-folder-color-switcher.py \
      --replace "/usr/share/folder-color-switcher/colors.d" "/run/current-system/sw/share/folder-color-switcher/colors.d"
=======
      --replace "/usr/share" "$out/share"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    mv usr/share $out

    runHook postInstall
  '';

<<<<<<< HEAD
  preFixup = ''
    # For Gdk.cairo_surface_create_from_pixbuf()
    # TypeError: Couldn't find foreign struct converter for 'cairo.Surface'
    buildPythonPath ${python3.pkgs.pycairo}
    patchPythonScript $out/share/nemo-python/extensions/nemo-folder-color-switcher.py
  '';

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    homepage = "https://github.com/linuxmint/folder-color-switcher";
    description = "Change folder colors for Nemo and Caja";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
}
