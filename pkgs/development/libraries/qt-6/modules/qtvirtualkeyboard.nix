{
  qtModule,
  qtbase,
  qtdeclarative,
  qtsvg,
  hunspell,
  pkg-config,
  fetchpatch,
}:

qtModule {
  pname = "qtvirtualkeyboard";
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
    qtsvg
    hunspell
  ];
  nativeBuildInputs = [ pkg-config ];
  patches = [
    # https://qt-project.atlassian.net/browse/QTBUG-137440
    (fetchpatch {
      name = "rb-link-core-into-styles.patch";
      url = "https://github.com/qt/qtvirtualkeyboard/commit/0b1e8be8dd874e1fbacd0c30ed5be7342f6cd44d.patch";
      hash = "sha256-Uk6EJOlkCRLUg1w3ljHaxV/dXEVWyUpP/ijoyjptbNc=";
    })
  ];
}
