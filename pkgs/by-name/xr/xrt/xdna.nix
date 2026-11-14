{
  lib,
  symlinkJoin,
  xrt,
  xrt-amdxdna-plugin,
}:

# Merge xrt (headers) with xrt-amdxdna-plugin (NPU-aware libs).
# The plugin comes first so that its libs take precedence over the base xrt ones.
symlinkJoin {
  name = "xrt-amdxdna-${xrt.version}";

  paths = [
    xrt-amdxdna-plugin
    xrt
  ];

  meta = {
    description = "Xilinx Runtime with AMD XDNA NPU support for Ryzen AI";
    homepage = "https://github.com/amd/xdna-driver";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      GaetanLepage
      JohnMolotov
    ];
    platforms = lib.platforms.linux;
  };
}
