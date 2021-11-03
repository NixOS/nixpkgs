{ lib, fetchFromGitHub, gnome, pop-desktop-widget, grilo }:

gnome.gnome-control-center.overrideAttrs (old: rec {
  pname = "pop-control-center";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "gnome-control-center";
    # from branch `master_impish`
    rev = "2dafb76ab69cf4c93e6dd8920c0e10b7cacf0d0f";
    sha256 = "sha256-SSu3eaSB+4dZNQvsOiQiviHqM+eo4PQkNH97oG3xecc=";
  };

  buildInputs = old.buildInputs ++ [ grilo pop-desktop-widget ];

  patches = let
    patchDir = "${src}/debian/patches";
  in old.patches ++ [
    # "${patchDir}/pop/pop-allow-sound-above-100.patch"
    "${patchDir}/pop/pop-mouse-accel.patch"
    "${patchDir}/pop/pop-shop.patch"
    # "${patchDir}/pop/pop-upgrade.patch"
    # "${patchDir}/pop/pop-hidpi.patch"
    # "${patchDir}/pop/system76-firmware.patch"
    "${patchDir}/pop/pop-alert-sound.patch"
    "${patchDir}/pop/remove-diagnostics.patch"
    # "${patchDir}/pop/gsettings-desktop-schemas-version.patch"
    "${patchDir}/pop/0001-mouse-Add-Disable-While-Typing-toggle-for-touchpad.patch"
    "${patchDir}/pop/0001-Do-not-enforce-password-strength-requirements.patch"
    "${patchDir}/pop/0002-users-Recreate-RunHandler-on-failure.patch"
    "${patchDir}/pop/cc-search-locations-dialog.patch"
    "${patchDir}/pop/0001-shell-Fix-bug-when-multiple-panels-use-custom-sideba.patch"
    "${patchDir}/pop/pop-desktop-widget.patch"
    "${patchDir}/pop/pop-no-search.patch"
    "${patchDir}/pop/0001-keyboard-Pop-_OS-changes-with-support-for-multiple-b.patch"
  ];

  meta = with lib; {
    description = "Modular IPC-based desktop launcher service for Pop!_OS";
    maintainers = with maintainers; [ Enzime ];
    license = licenses.gpl3;
    homepage = "https://github.com/pop-os/gnome-control-center";
  };
})
