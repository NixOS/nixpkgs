{ glfw }:
glfw.overrideAttrs (old: {
  pname = "glfw-wayland-minecraft";

  patches = old.patches or [] ++ [
    ./0009-Defer-setting-cursor-position-until-the-cursor-is-lo.patch
  ];
})
