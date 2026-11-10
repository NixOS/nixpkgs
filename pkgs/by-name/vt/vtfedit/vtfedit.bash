#!/usr/bin/env bash

set -e

OUT="@out@"
PATH="@path@:$PATH"

PKGNAME="vtfedit"
PKGBIN="$OUT/share/lib/VTFEdit.exe"

export WINEDEBUG="-all"
export WINEPREFIX="$HOME/.local/share/$PKGNAME/wine"

if [[ ! -d "$WINEPREFIX" ]]; then
  echo "Initialising the Wine prefix..."
  WINEDLLOVERRIDES="mscoree=" winetricks -q winxp
  echo "Installing DLLs..."
  winetricks -q dlls dotnet20 vcrun2005
fi

wine "$PKGBIN" "$@"
