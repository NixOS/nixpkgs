{ lib, fetchurl }:
# When updating this package, please verify at least these build (assuming x86_64-linux):
# nix build .#mesa .#pkgsi686Linux.mesa .#pkgsCross.aarch64-multiplatform.mesa .#pkgsMusl.mesa
# Ideally also verify:
# nix build .#legacyPackages.x86_64-darwin.mesa .#legacyPackages.aarch64-darwin.mesa
rec {
  pname = "mesa";
  version = "24.1.5";

  src = fetchurl {
    urls = [
      "https://archive.mesa3d.org/mesa-${version}.tar.xz"
      "https://mesa.freedesktop.org/archive/mesa-${version}.tar.xz"
    ];
    hash = "sha256-AnYf/ZZd1kuVQh6/yhGR1zckq6APMANACSN1ZPNM+XY=";
  };

  meta = {
    description = "Open source 3D graphics library";
    longDescription = ''
      The Mesa project began as an open-source implementation of the OpenGL
      specification - a system for rendering interactive 3D graphics. Over the
      years the project has grown to implement more graphics APIs, including
      OpenGL ES (versions 1, 2, 3), OpenCL, OpenMAX, VDPAU, VA API, XvMC, and
      Vulkan.  A variety of device drivers allows the Mesa libraries to be used
      in many different environments ranging from software emulation to
      complete hardware acceleration for modern GPUs.
    '';
    homepage = "https://www.mesa3d.org/";
    changelog = "https://www.mesa3d.org/relnotes/${version}.html";
    license = with lib.licenses; [ mit ]; # X11 variant, in most files
    platforms = lib.platforms.mesaPlatforms;
    maintainers = with lib.maintainers; [ primeos vcunat ]; # Help is welcome :)
  };
}
