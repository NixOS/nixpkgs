{
  lib,
  stdenv,

  pythonPackages,
  qmake,
  qscintilla,
  qtbase,
  qtmacextras ? null,
}:

let
  qtVersion = lib.versions.major qtbase.version;
  pyQtPackage = pythonPackages."pyqt${qtVersion}";

  inherit (pythonPackages)
    isPy3k
    python
    sip
    pyqt-builder
    ;
in
pythonPackages.buildPythonPackage {
  pname = "qscintilla-qt${qtVersion}";
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

  propagatedBuildInputs = [
    pyQtPackage
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ qtmacextras ];

  dontWrapQtApps = true;

  postPatch = ''
    cd Python
    cp pyproject-qt${qtVersion}.toml pyproject.toml
    echo '[tool.sip.project]' >> pyproject.toml
    echo 'sip-include-dirs = [ "${pyQtPackage}/${python.sitePackages}/PyQt${qtVersion}/bindings"]' \
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

  pythonImportsCheck = [ "PyQt${qtVersion}.Qsci" ];

  meta = with lib; {
    description = "Python binding to QScintilla, Qt based text editing control";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ lsix ];
    homepage = "https://www.riverbankcomputing.com/software/qscintilla/";
  };
}
