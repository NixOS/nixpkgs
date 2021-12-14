{ lib
, pythonPackages
, qscintilla
, qtbase
, qmake
, qtmacextras ? null
, stdenv
}:

let
  inherit (pythonPackages) buildPythonPackage isPy3k python sip sipbuild pyqt5 pyqt-builder;
in buildPythonPackage rec {
  pname = "qscintilla";
  version = qscintilla.version;
  src = qscintilla.src;
  format = "pyproject";

  disabled = !isPy3k;

  nativeBuildInputs = [ sip qmake pyqt-builder ];
  buildInputs = [ qtbase qscintilla ];
  propagatedBuildInputs = [ pyqt5 pyqt5 ] ++ lib.optional (stdenv.isDarwin) qtmacextras;

  dontWrapQtApps = true;

  # postPatch = ''
  #   substituteInPlace Python/configure.py \
  #     --replace \
  #     "target_config.py_module_dir" \
  #     "'$out/${python.sitePackages}'"
  # '';
  #

  qsciFeaturesDir = qscintilla + "/mkspecs/features";
  qsciIncludeDir = qscintilla + "/include";
  qsciLibraryDir = qscintilla + "/lib";
  sipIncludeDirs = pyqt5 + "/" + python.sitePackages + "/PyQt5/bindings";
  apiDir = qscintilla + "/share";

  postPatch = ''
    cd Python
    cp pyproject-qt5.toml pyproject.toml
    echo '[tool.sip.project]' >> pyproject.toml
    echo 'sip-include-dirs = [ "${sipIncludeDirs}" ]' >> pyproject.toml
  '';

  dontConfigure = true;
    # substituteInPlace configure.py \
    #   --replace "qmake = {'CONFIG': 'qscintilla2'}" "qmake = {'CONFIG': 'qscintilla2', 'QT': 'widgets printsupport'}"
    # ${python.executable} ./configure.py \
    #   --pyqt=PyQt5 \
    #   --destdir=$out/${python.sitePackages}/PyQt5 \
    #   --stubsdir=$out/${python.sitePackages}/PyQt5 \
    #   --apidir=$out/api/${python.libPrefix} \
    #   --qsci-incdir=${qscintilla}/include \
    #   --qsci-featuresdir=${qscintilla}/mkspecs/features \
    #   --qsci-libdir=${qscintilla}/lib \
    #   --pyqt-sipdir=${pyqt5}/${python.sitePackages}/PyQt5/bindings \
    #   --qsci-sipdir=$out/share/sip/PyQt5 \
    #   --sip-incdir=${sip}/include
    #

  build = "sip-install --qsci-features-dir ${qsciFeaturesDir} --qsci-include-dir ${qsciIncludeDir} \
           --qsci-library-dir ${qsciLibraryDir} --api-dir ${apiDir}" + lib.optionalString stdenv.isDarwin
           " --qmake-setting 'QT += widgets'";

  postInstall = ''
    # Needed by pythonImportsCheck to find the module
    export PYTHONPATH="$out/${python.sitePackages}:$PYTHONPATH"
  '';

  # Checked using pythonImportsCheck
  doCheck = false;

  pythonImportsCheck = [ "PyQt5.Qsci" ];

  meta = with lib; {
    description = "A Python binding to QScintilla, Qt based text editing control";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ lsix ];
    homepage = "https://www.riverbankcomputing.com/software/qscintilla/";
  };
}
