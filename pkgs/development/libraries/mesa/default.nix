{stdenv, fetchurl, pkgconfig, x11, libXmu, libXi, makedepend, libdrm, glproto, libXxf86vm}:

let

  target =
    if stdenv.system == "i686-linux" then "linux-dri-x86" else
    if stdenv.system == "x86_64-linux" then "linux-dri-x86-64" else
    abort "unsupported platform for Mesa"; # !!! change to throw, remove all the mesa asserts in all-packages.nix

in

stdenv.mkDerivation {
  name = "mesa-6.5.2";
  src = fetchurl {
    url = http://mesh.dl.sourceforge.net/sourceforge/mesa3d/MesaLib-6.5.2.tar.bz2;
    sha256 = "0pxq3zjfdgcpkc92cyzl9hskdmc8qxxp7b2smywixmb10jim0zqk";
  };
  buildFlags = "${target}";
  preBuild = "
    makeFlagsArray=(INSTALL_DIR=$out DRI_DRIVER_INSTALL_DIR=$out/lib/modules/dri)
  ";
/*    (fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/MesaGLUT-6.4.tar.bz2;
      md5 = "1a8c4d4fc699233f5fdb902b8753099e";
    })
    (fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/MesaDemos-6.4.tar.bz2;
      md5 = "1a8c4d4fc699233f5fdb902b8753099e";
    }) */
  buildInputs = [pkgconfig x11 libXmu libXi makedepend libdrm glproto libXxf86vm];
  passthru = {inherit libdrm;};
  meta = {description = "OpenGL-compatible 3D library. Supports acceleration.";};
}
