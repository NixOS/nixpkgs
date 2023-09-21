{ mkDerivation
, lib
, fetchpatch
, extra-cmake-modules
, kauth
, kconfig
, kcoreaddons
, kcrash
, kdbusaddons
, kfilemetadata
, ki18n
, kidletime
, kio
, lmdb
, qtbase
, qtdeclarative
, solid
,
}:

mkDerivation {
  pname = "baloo";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kauth kconfig kcrash kdbusaddons ki18n kio kidletime lmdb qtdeclarative solid ];
  outputs = [ "out" "dev" ];
  propagatedBuildInputs = [ kcoreaddons kfilemetadata qtbase ];

  # baloo suffers from issues when running on btrfs as well as with certain LVM/dm-crypt setups
  # where the device id will change on reboot causing baloo to reindex all the files and then having
  # duplicate files. A patch has been proposed that addresses this, which has not been accepted yet.
  # However, without this patch, people tend to disable baloo rather than dealing with the constant
  # reindexing.
  #
  # https://bugs.kde.org/show_bug.cgi?id=402154
  patches = [
    (fetchpatch {
      url = "https://bugsfiles.kde.org/attachment.cgi?id=159031";
      hash = "sha256-hCtNXUpRhIP94f7gpwTGWWh1h/7JRRJaRASIwHWQjnY=";
      name = "use_fsid.patch";
    })
  ];

  # kde-baloo.service uses `ExecCondition=@KDE_INSTALL_FULL_BINDIR@/kde-systemd-start-condition ...`
  # which comes from the "plasma-workspace" derivation, but KDE_INSTALL_* all point at the "baloo" one
  # (`${lib.getBin pkgs.plasma-workspace}` would cause infinite recursion)
  postUnpack = ''
    substituteInPlace "$sourceRoot"/src/file/kde-baloo.service.in \
      --replace @KDE_INSTALL_FULL_BINDIR@ /run/current-system/sw/bin
  '';
  meta.platforms = lib.platforms.linux ++ lib.platforms.freebsd;
}
