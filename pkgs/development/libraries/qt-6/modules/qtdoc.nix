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
  cmakeFlags = [
    "-DCMAKE_MESSAGE_LOG_LEVEL=STATUS"
  ];
  dontUseNinjaBuild = true;
  buildFlags = [ "docs" ];
  dontUseNinjaInstall = true;
  installFlags = [ "install_docs" ];
  outputs = [ "out" ];
}
