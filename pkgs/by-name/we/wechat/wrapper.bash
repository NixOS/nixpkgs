#!/usr/bin/env bash

if [ -z "${QT_QPA_PLATFORM:-}" ]; then
  if [ -n "${WAYLAND_DISPLAY:-}" ] || [ "${XDG_SESSION_TYPE:-}" = wayland ]; then
    export QT_QPA_PLATFORM=wayland
  else
    export QT_QPA_PLATFORM=xcb
  fi
fi

case "$QT_QPA_PLATFORM" in
  wayland*)
    # The bundled Qt needs text-input-v3 under native Wayland.
    export QT_IM_MODULE="${QT_IM_MODULE-text-input-unstable-v3}"

    # With Xwayland scaling disabled, match Qt DPI to Xft.dpi * the WebUI scale.
    # Fold both scale factors into DPI scaling to keep the two UIs in sync.
    scale_settings=$(
      set -o pipefail
      if [ -n "${DISPLAY:-}" ]; then
        # An unresponsive X server must not hang startup.
        "@timeout@" --kill-after=1s 2s "@xrdb@" -query
      fi | LC_ALL=C "@awk@" \
        -v gtk_scale="${GDK_SCALE:-}" \
        -v gtk_dpi_scale="${GDK_DPI_SCALE:-}" \
        -v qt_scale="${QT_SCALE_FACTOR:-1}" \
        -v qt_font_dpi="${QT_FONT_DPI:-}" '
          BEGIN { dpi = 96 }
          $1 == "Xft.dpi:" { dpi = $2 }
          END {
            # Keep the WebUI scale when Qt and GTK settings disagree.
            if (gtk_scale != "" || gtk_dpi_scale != "")
              scale = (gtk_scale == "" ? 1 : gtk_scale) * (gtk_dpi_scale == "" ? 1 : gtk_dpi_scale)
            else
              scale = qt_scale * (qt_font_dpi == "" ? dpi : qt_font_dpi) / dpi
            printf "%.12g %.12g\n", scale * dpi, scale
          }
        ')
    read -r QT_FONT_DPI GDK_DPI_SCALE <<< "$scale_settings"
    export QT_FONT_DPI GDK_DPI_SCALE
    export QT_SCALE_FACTOR=1 GDK_SCALE=1
    ;;
esac

# The WebUI uses GTK input methods independently of the native Qt UI.
case "${XMODIFIERS:-}" in
  *fcitx*)
    case "$QT_QPA_PLATFORM" in
      xcb*) export QT_IM_MODULE="${QT_IM_MODULE-fcitx}" ;;
    esac
    export GTK_IM_MODULE="${GTK_IM_MODULE-fcitx}"
    ;;
  *ibus*)
    case "$QT_QPA_PLATFORM" in
      xcb*) export QT_IM_MODULE="${QT_IM_MODULE-ibus}" ;;
    esac
    export GTK_IM_MODULE="${GTK_IM_MODULE-ibus}"
    if [ "${QT_IM_MODULE:-}" = ibus ] || [ "${GTK_IM_MODULE:-}" = ibus ]; then
      export IBUS_USE_PORTAL="${IBUS_USE_PORTAL-1}"
    fi
    ;;
esac
