#! @bash@/bin/bash
# shellcheck shell=bash

# fixes issues like
# libdbusmenu-gtk3-aarch64-unknown-linux-gnu> /build/libdbusmenu-16.04.0/libdbusmenu-gtk/tmp-introspect2jhtiwwn/.libs/DbusmenuGtk3-0.4:
# error while loading shared libraries: libdbusmenu-glib.so.4: cannot open shared object file: No such file or directory
# in non-meson builds

# see: https://github.com/void-linux/void-packages/blob/master/srcpkgs/gobject-introspection/files/g-ir-scanner-qemuwrapper
# https://github.com/openembedded/openembedded-core/blob/c5a14f39a6717a99b510cb97aa2fb403d4b98d99/meta/recipes-gnome/gobject-introspection/gobject-introspection_1.72.0.bb#L74
while read -r d; do \
    # some meson projects may have subprojects which use makefiles for docs(e.g. gi-docgen), ignore those as they will never be needed
    if [[ -f "$d/Makefile" && "$d" != *"subproject"* ]]; then
        GIR_EXTRA_LIBS_PATH="$(readlink -f "$d/.libs"):$GIR_EXTRA_LIBS_PATH"
        export GIR_EXTRA_LIBS_PATH
    fi
done < <(find "$NIX_BUILD_TOP" -type d)

# quoting broke the build of atk
# shellcheck disable=2086
exec @emulator@ ${GIR_EXTRA_OPTIONS:-} \
    ${GIR_EXTRA_LIBS_PATH:+-E LD_LIBRARY_PATH="${GIR_EXTRA_LIBS_PATH}"} \
    "$@"
