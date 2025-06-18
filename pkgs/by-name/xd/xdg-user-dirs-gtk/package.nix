{
  stdenv,
  lib,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  xdg-user-dirs,
  wrapGAppsHook3,
  gtk3,
  gnome,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xdg-user-dirs-gtk";
  version = "0.14";

  src = fetchurl {
    url = "mirror://gnome/sources/xdg-user-dirs-gtk/${lib.versions.majorMinor finalAttrs.version}/xdg-user-dirs-gtk-${finalAttrs.version}.tar.xz";
    hash = "sha256-U3++FCskc27XiU5KAfaf11jLbHpnejgoeVKdIX9KKHM=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    xdg-user-dirs
    wrapGAppsHook3
  ];

  buildInputs = [ gtk3 ];

  postPatch = ''
    # Fetch “xdg-user-dirs” translations from correct localedir.
    substituteInPlace update.c --replace-fail \
      'bindtextdomain ("xdg-user-dirs", GLIBLOCALEDIR);' \
      'bindtextdomain ("xdg-user-dirs", "${xdg-user-dirs}/share/locale");'

    patchShebangs meson_custom_install_desktop_file.sh
  '';

  preFixup = ''
    gappsWrapperArgs+=(--prefix PATH : "${lib.makeBinPath [ xdg-user-dirs ]}")
  '';

  passthru.updateScript = gnome.updateScript {
    packageName = "xdg-user-dirs-gtk";
  };

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/xdg-user-dirs-gtk";
    description = "Companion to xdg-user-dirs that integrates it into the GNOME desktop and GTK applications";
    license = lib.licenses.gpl2Plus;
    teams = [ lib.teams.gnome ];
    platforms = lib.platforms.unix;
    mainProgram = "xdg-user-dirs-gtk-update";
  };
})
