{
  stdenv,

  tracy-glfw,
  tracy-wayland,
}:
if (stdenv.isLinux) then tracy-wayland else tracy-glfw
