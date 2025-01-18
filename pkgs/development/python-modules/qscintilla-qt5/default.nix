{
  lib,
  pythonPackages,
  qscintilla,
  qtbase,
  qmake,
  qtmacextras,
  stdenv,
}:

let
  inherit (pythonPackages)
    buildPythonPackage
    isPy3k
    python
    sip
    sipbuild
    pyqt5
    pyqt-builder
    ;
in
buildPythonPackage rec {
  pname = "qscintilla-qt5";
  version = qscintilla.version;
  src = qscintilla.src;
  format = "pyproject";

  disabled = !isPy3k;

  nativeBuildInputs = [
    sip
    qmake
    pyqt-builder
    qscintilla
    pythonPackages.setuptools
  ];
  buildInputs = [ qtbase ];
  propagatedBuildInputs = [ pyqt5 ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ qtmacextras ];

  dontWrapQtApps = true;

  postPatch =
    ''
      cd Python
      cp pyproject-qt5.toml pyproject.toml
      echo '[tool.sip.project]' >> pyproject.toml
      echo 'sip-include-dirs = [ "${pyqt5}/${python.sitePackages}/PyQt5/bindings"]' \
         >> pyproject.toml
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      substituteInPlace project.py \
        --replace \
        "if self.project.qsci_external_lib:
                  if self.qsci_features_dir is not None:" \
        "if self.project.qsci_external_lib:
                  self.builder_settings.append('QT += widgets')

                  self.builder_settings.append('QT += printsupport')

                  if self.qsci_features_dir is not None:"
    '';

  dontConfigure = true;

  build = ''
    sip-install --qsci-features-dir ${qscintilla}/mkspecs/features \
    --qsci-include-dir ${qscintilla}/include \
    --qsci-library-dir ${qscintilla}/lib --api-dir ${qscintilla}/share";
  '';
  postInstall = ''
    # Needed by pythonImportsCheck to find the module
    export PYTHONPATH="$out/${python.sitePackages}:$PYTHONPATH"
  '';

  # Checked using pythonImportsCheck
  doCheck = false;

  pythonImportsCheck = [ "PyQt5.Qsci" ];

  meta = with lib; {
    description = "Python binding to QScintilla, Qt based text editing control";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ lsix ];
    homepage = "https://www.riverbankcomputing.com/software/qscintilla/";
  };
}
