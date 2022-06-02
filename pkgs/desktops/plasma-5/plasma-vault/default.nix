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
  pname = "plasma-vault";
  nativeBuildInputs = [ extra-cmake-modules ];

  patches = [
    ./0001-encfs-path.patch
    ./0002-cryfs-path.patch
    ./0003-fusermount-path.patch
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
