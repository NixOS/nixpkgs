LXQtCMakePostHook() {
  cmakeFlagsArray+=(
    -DLXQT_LIBRARY_NAME=lxqt
    -DLXQT_SHARE_DIR=$out/share/lxqt
    -DLXQT_TRANSLATIONS_DIR=$out/share/lxqt/translations
    -DLXQT_GRAPHICS_DIR=$out/share/lxqt/graphics
    -DLXQT_ETC_XDG_DIR=$out/etc/xdg
    -DLXQT_DATA_DIR=$out/share
    -DLXQT_RELATIVE_SHARE_DIR=lxqt
    -DLXQT_RELATIVE_SHARE_TRANSLATIONS_DIR=lxqt/translations
  )

}

postHooks+=(LXQtCMakePostHook)
