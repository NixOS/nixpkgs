{ pkgs
, stdenv
, driversi686Linux
, pkgsi686Linux
, amdgpu-pro-libs
, amdvlk
, mesa
, libGL
, with32bit ? true
}:
let
  amf-amd-pro = amdgpu-pro-libs.amf;
  vulkan-amd-pro = amdgpu-pro-libs.vulkan;
  oglp-amd-pro = amdgpu-pro-libs.opengl;

  vulkan-amd-pro32 = pkgsi686Linux.amdgpu-pro-libs.vulkan;
  oglp-amd-pro32 = pkgsi686Linux.amdgpu-pro-libs.opengl;
in
pkgs.buildEnv {

  name = "amdgpu-pro-prefixes";
  paths = with pkgs; [
    (writeShellScriptBin "vk_pro"
      ''
        export DISABLE_LAYER_AMD_SWITCHABLE_GRAPHICS_1=1
        export VK_ICD_FILENAMES="${vulkan-amd-pro}/share/vulkan/icd.d/amd_pro_icd64.json"
        export LD_LIBRARY_PATH="${amf-amd-pro}/lib:$LD_LIBRARY_PATH"
        ${(if with32bit then ''export VK_ICD_FILENAMES=$VK_ICD_FILENAMES:${vulkan-amd-pro32}/share/vulkan/icd.d/amd_pro_icd32.json'' else "")}
        "$@"
      ''
    )
    (writeShellScriptBin "vk_amdvlk"
      ''
        export DISABLE_LAYER_AMD_SWITCHABLE_GRAPHICS_1=1
        export VK_ICD_FILENAMES="${amdvlk}/share/vulkan/icd.d/amd_icd64.json"
        ${(if with32bit then ''export VK_ICD_FILENAMES=$VK_ICD_FILENAMES:${driversi686Linux.amdvlk}/share/vulkan/icd.d/amd_icd32.json'' else "")}
        "$@"
      ''
    )

    (writeShellScriptBin "vk_radv"
      ''
        export DISABLE_LAYER_AMD_SWITCHABLE_GRAPHICS_1=1
        export VK_ICD_FILENAMES="${mesa.drivers}/share/vulkan/icd.d/radeon_icd.x86_64.json"
        ${(if with32bit then ''export VK_ICD_FILENAMES=$VK_ICD_FILENAMES:${driversi686Linux.mesa.drivers}/share/vulkan/icd.d/radeon_icd.i686.json'' else "")}
        "$@"
      ''
    )

    (writeShellScriptBin "gl_pro"
      ''
        export __GLX_VENDOR_LIBRARY_NAME=amd
        export LIBGL_DRIVERS_PATH="${oglp-amd-pro}/lib/dri"
        ${(if with32bit then ''
        export LD_LIBRARY_PATH="${oglp-amd-pro32}/lib:$LD_LIBRARY_PATH"
        export LIBGL_DRIVERS_PATH="$LIBGL_DRIVERS_PATH:${oglp-amd-pro32}/lib/dri"
        '' else "")}
        export LD_LIBRARY_PATH="${oglp-amd-pro}/lib:$LD_LIBRARY_PATH"
        "$@"
      ''
    )
    (writeShellScriptBin "gl_zink"
      ''
        ${(if with32bit then ''export LD_LIBRARY_PATH="${pkgsi686Linux.libGL}/lib:$LD_LIBRARY_PATH"'' else "")}
        export LD_LIBRARY_PATH="${libGL}/lib:$LD_LIBRARY_PATH"
        export __GLX_VENDOR_LIBRARY_NAME=mesa
        export MESA_LOADER_DRIVER_OVERRIDE=zink
        export GALLIUM_DRIVER=zink

        "$@"
      ''
    )
    (writeShellScriptBin "gl_radeonsi"
      ''
        ${(if with32bit then ''export LD_LIBRARY_PATH="${pkgsi686Linux.libGL}/lib:$LD_LIBRARY_PATH"'' else "")}
        export LD_LIBRARY_PATH="${libGL}/lib:$LD_LIBRARY_PATH"
        export __GLX_VENDOR_LIBRARY_NAME=mesa
        export MESA_LOADER_DRIVER_OVERRIDE=radeonsi
        export GALLIUM_DRIVER=radeonsi

        "$@"
      ''
    )
  ];

  meta = with pkgs.lib; {
    description = "AMDGPU Pro helper prefixes";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ materus ];
  };
}
