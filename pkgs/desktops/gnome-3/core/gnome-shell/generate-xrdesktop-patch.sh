#!/bin/bash

SHELL_VER=$(nix eval '(import ../../../../../. {}).gnome3.gnome-shell.version' | sed "s|\"||g")
XRDESKTOP_VER=$(nix eval '(import ../../../../../. {}).xrdesktop.version' | sed "s|\"||g")


XR_REV="$SHELL_VER-xrdesktop-$XRDESKTOP_VER"
# https://gitlab.freedesktop.org/xrdesktop/gnome-shell.git $XR_REV
# ...
# https://gitlab.gnome.org/GNOME/gnome-shell.git $SHELL_VER

TMP=$(mktemp -d)
REPO="$TMP/repo"

git clone https://gitlab.freedesktop.org/xrdesktop/gnome-shell.git "$REPO"
git -C "$REPO" remote add upstream "https://gitlab.gnome.org/GNOME/gnome-shell.git"
git -C "$REPO" fetch upstream
git -C "$REPO" diff "$SHELL_VER" "$XR_REV" > xrdesktop.patch

