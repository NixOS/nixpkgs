# shellcheck shell=bash

# Mesa: force software rendering
# https://docs.mesa3d.org/envvars.html
export LIBGL_ALWAYS_SOFTWARE=true
export LIBGL_DRIVERS_PATH=@mesa@/lib/dri

# GLX
# glvnd just does dlopen("libGLX_%s.so"), so we have to resort to
# LD_LIBRARY_PATH, which is bad but what can you do.
# FIXME: maybe change glvnd to allow specifying this properly
export LD_LIBRARY_PATH=@mesa@/lib:${LD_LIBRARY_PATH:-}
export __GLX_VENDOR_LIBRARY_NAME=mesa

# EGL
# https://github.com/NVIDIA/libglvnd/blob/master/src/EGL/icd_enumeration.md
export __EGL_VENDOR_LIBRARY_FILENAMES=@mesa@/share/glvnd/egl_vendor.d/50_mesa.json

# GBM
export GBM_BACKENDS_PATH=@mesa@/lib/gbm
export GBM_BACKEND=dri

# Vulkan
# https://github.com/KhronosGroup/Vulkan-Loader/blob/main/docs/LoaderInterfaceArchitecture.md
# glob because the filenames contain an architecture suffix
# echo is needed to force-expand the glob
VK_DRIVER_FILES="$(echo @mesa@/share/vulkan/icd.d/lvp_icd.*.json)"
export VK_DRIVER_FILES
