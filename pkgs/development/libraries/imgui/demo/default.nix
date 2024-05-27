{
  lib,
  stdenv,
  cmake,
  imgui,
  glew,
}:

stdenv.mkDerivation {
  pname = "${imgui.pname}-demo";
  inherit (imgui) version;

  nativeBuildInputs = [ cmake ];
  buildInputs = [ (imgui.override { IMGUI_BUILD_GLFW_BINDING = true; }) ];

  src = ./.;

  meta.mainProgram = "demo";
}
