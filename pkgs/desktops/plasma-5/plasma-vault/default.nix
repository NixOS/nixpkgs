{
  mkDerivation, lib,
  extra-cmake-modules,

  kactivities,
  plasma-framework,
  kwindowsystem,
  networkmanager-qt,
  libksysguard,

  encfs,
  cryfs,
  fuse
}:

mkDerivation {
  name = "plasma-vault";
  nativeBuildInputs = [ extra-cmake-modules ];

  patches = [
    ./encfs-path.patch
    ./cryfs-path.patch
    ./fusermount-path.patch
  ];

  buildInputs = [
    kactivities plasma-framework kwindowsystem libksysguard
    networkmanager-qt
  ];

  CXXFLAGS = [
    ''-DNIXPKGS_ENCFS=\"${lib.getBin encfs}/bin/encfs\"''
    ''-DNIXPKGS_ENCFSCTL=\"${lib.getBin encfs}/bin/encfsctl\"''

    ''-DNIXPKGS_CRYFS=\"${lib.getBin cryfs}/bin/cryfs\"''

    ''-DNIXPKGS_FUSERMOUNT=\"${lib.getBin fuse}/bin/fusermount\"''
  ];

}
