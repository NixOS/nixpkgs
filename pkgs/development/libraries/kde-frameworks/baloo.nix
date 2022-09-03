{
  mkDerivation,
  extra-cmake-modules,
  kauth, kconfig, kcoreaddons, kcrash, kdbusaddons, kfilemetadata, ki18n,
  kidletime, kio, lmdb, qtbase, qtdeclarative, solid,
}:

mkDerivation {
  pname = "baloo";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    kauth kconfig kcrash kdbusaddons ki18n kio kidletime lmdb qtdeclarative
    solid
  ];
  outputs = [ "out" "dev" ];
  propagatedBuildInputs = [ kcoreaddons kfilemetadata qtbase ];

  # kde-baloo.service uses `ExecCondition=@KDE_INSTALL_FULL_BINDIR@/kde-systemd-start-condition ...`
  # which comes from the "plasma-workspace" derivation, but KDE_INSTALL_* all point at the "baloo" one
  # (`${lib.getBin pkgs.plasma-workspace}` would cause infinite recursion)
  postUnpack = ''
    substituteInPlace "$sourceRoot"/src/file/kde-baloo.service.in \
      --replace @KDE_INSTALL_FULL_BINDIR@ /run/current-system/sw/bin
  '';
}
