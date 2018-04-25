{
  mkDerivation, lib, fetchpatch,
  extra-cmake-modules, gettext, python,
  qtbase, qtdeclarative, qtscript,
}:

mkDerivation {
  name = "ki18n";
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
    broken = builtins.compareVersions qtbase.version "5.7.0" < 0;
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedNativeBuildInputs = [ gettext python ];
  buildInputs = [ qtdeclarative qtscript ];
  patches = [
    (fetchpatch {
      url = "https://phabricator.kde.org/D12216?download=true";
      sha256 = "04gpyb11vlgivqjx3lqdwgqb4ss5bphy5zmh65k57bbv4rnlsm15";
    })
  ];
}
