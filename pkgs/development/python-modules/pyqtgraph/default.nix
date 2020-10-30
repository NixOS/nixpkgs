{ stdenv
, buildPythonPackage
, fetchFromGitHub
, scipy
, numpy
, pyqt5
, pyopengl
, h5py
, qt5
, python
, pytest
, freefont_ttf
, makeFontsConf
}:

let
  fontsConf = makeFontsConf {
    fontDirectories = [ freefont_ttf ];
  };
in buildPythonPackage rec {
  pname = "pyqtgraph";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "pyqtgraph";
    repo = "pyqtgraph";
    rev = "pyqtgraph-${version}";
    sha256 = "03fvpkqdn80ni51msvyivmghw41qk4vplwdqndkvzzzlppimdjbn";
  };

  propagatedBuildInputs = [ numpy pyqt5 scipy pyopengl h5py ];

  checkInputs = [ pytest ];

  checkPhase = ''
    export QT_PLUGIN_PATH="${qt5.qtbase.bin}/${qt5.qtbase.qtPluginPrefix}"
    export QT_QPA_PLATFORM=offscreen
    export DYLD_FRAMEWORK_PATH=/System/Library/Frameworks
    export FONTCONFIG_FILE=${fontsConf}

    # disable 6 tests which try to clone https://github.com/pyqtgraph/test-data
    ${python.interpreter} test.py --pyqt5 \
      -k "not test_ImageItem and not test_ImageItem_axisorder \
      and not test_PlotCurveItem and not test_getArrayRegion \
      and not test_getArrayRegion_axisorder and not test_PolyLineROI"
  '';

  meta = with stdenv.lib; {
    description = "Scientific Graphics and GUI Library for Python";
    homepage = "http://www.pyqtgraph.org/";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ koral ];
  };

}
