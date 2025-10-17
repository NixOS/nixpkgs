{
  qtModule,
  qtdeclarative,
  qtbase,
  qttools,
}:

qtModule {
  pname = "qtdoc";
  # avoid fix-qt-builtin-paths hook substitute QT_INSTALL_DOCS to qtdoc's path
  postPatch = ''
    for file in $(grep -rl '$QT_INSTALL_DOCS'); do
      substituteInPlace $file \
          --replace '$QT_INSTALL_DOCS' "${qtbase}/share/doc"
    done
  '';
  nativeBuildInputs = [ (qttools.override { withClang = true; }) ];
  propagatedBuildInputs = [ qtdeclarative ];

  ninjaFlags = [ "docs" ];
  installTargets = [ "install_docs" ];
}
