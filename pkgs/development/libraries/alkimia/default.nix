{
  lib,
  stdenv,
  fetchFromGitLab,
  extra-cmake-modules,
  doxygen,
  graphviz,
  qtbase,
  qtwebengine,
  mpir,
  kdelibs4support,
  plasma-framework,
  knewstuff,
  kpackage,
  wrapQtAppsHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "alkimia";
  version = "8.2.0";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "office";
    repo = "alkimia";
    rev = "v${finalAttrs.version}";
    hash = "sha256-1unlpGTJaAMhYacMO2totq0JFNaYffgieJsYa18DtkY=";
  };

  nativeBuildInputs = [
    extra-cmake-modules
    doxygen
    graphviz
    wrapQtAppsHook
  ];

  # qtwebengine is not a mandatory dependency, but it adds some features
  # we might need for alkimia's dependents. See:
  # https://github.com/KDE/alkimia/blob/v8.1.2/CMakeLists.txt#L124
  buildInputs = [
    qtbase
    qtwebengine
    kdelibs4support
    plasma-framework
    knewstuff
    kpackage
  ];

  propagatedBuildInputs = [ mpir ];

  meta = {
    description = "Library used by KDE finance applications";
    mainProgram = "onlinequoteseditor5";
    longDescription = ''
      Alkimia is the infrastructure for common storage and business
      logic that will be used by all financial applications in KDE.

      The target is to share financial related information over
      application boundaries.
    '';
    license = lib.licenses.lgpl21Plus;
    platforms = qtbase.meta.platforms;
  };
})
