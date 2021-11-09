/*
FIXME
The following OPTIONAL packages have not been found:
 * Qt6Quick
-> qtdeclarative?
*/

{ qtModule
, qtbase
, libglvnd, libxkbcommon, vulkan-headers, libX11, libXcomposite
# TODO should be inherited from qtbase
, qtquick3d
, qtdeclarative
, wayland
, pkg-config
, xlibsWrapper
, libdrm
}:

qtModule {
  pname = "qtwayland";
  qtInputs = [
    qtbase
    #qtdeclarative # qtquick not here?
  ];
  buildInputs = [ wayland pkg-config xlibsWrapper libdrm
    libglvnd libxkbcommon vulkan-headers libX11 libXcomposite ];
  outputs = [ "out" "dev" "bin" ];
/*
  # FIXME qtdeclarative cmake files?
  # add LINK_DIRECTORIES to
  # /nix/store/ifp0qbw57pxqsddpmpvnw2wgyxhcbmsq-qtdeclarative-6.2.1-dev/lib/cmake/Qt6Quick/Qt6QuickTargets.cmake
  # set_target_properties(Qt6::Quick PROPERTIES
  preConfigure = ''
    export LD_LIBRARY_PATH="${qtdeclarative}/lib:$LD_LIBRARY_PATH"
  '';
*/
}
