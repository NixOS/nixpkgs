# shellcheck shell=bash

# https://docs.mesa3d.org/envvars.html
export LIBGL_ALWAYS_SOFTWARE=true
export LIBGL_DRIVERS_PATH=@drivers@/lib/dri

# https://github.com/NVIDIA/libglvnd/blob/master/src/EGL/icd_enumeration.md
export __EGL_VENDOR_LIBRARY_FILENAMES=@drivers@/share/glvnd/egl_vendor.d/50_mesa.json

# https://github.com/KhronosGroup/Vulkan-Loader/blob/main/docs/LoaderInterfaceArchitecture.md
# glob because the filenames contain an architecture suffix
# echo is needed to force-expand the glob
VK_DRIVER_FILES="$(echo @drivers@/share/vulkan/icd.d/lvp_icd.*.json)"
export VK_DRIVER_FILES
