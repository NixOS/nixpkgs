{ lib
, buildPythonPackage
, isPy3k
, fetchPypi
, sip
, qtbase
, qmake
, pyqt5
, pyqt-builder
, poppler
, pkg-config
, fetchpatch
}:

buildPythonPackage rec {
  pname = "python-poppler-qt5";
  version = "21.1.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0b82gm4i75q5v19kfbq0h4y0b2vcwr2213zkhxh6l0h45kdndmxd";
  };

  patches = [
    # Fix for https://github.com/frescobaldi/python-poppler-qt5/issues/43 (from PR #45)
    (fetchpatch {
      url = "https://github.com/frescobaldi/python-poppler-qt5/commit/40e71ad88173d02648bceb2438bc0567e60dacd5.patch";
      sha256 = "0c93d0k7b1n2s2njl8g92x6vw3z96da1fczah9qx07x08iw8dzi5";
    })
  ];

  buildInputs = [ qtbase.dev poppler pyqt-builder ];
  nativeBuildInputs = [ pkg-config qmake sip ];
  propagatedBuildInputs = [ pyqt5.dev ];

  format = "pyproject";
  dontConfigure = true;

  postPatch = ''
    cat <<EOF >> pyproject.toml
    [tool.sip.bindings.Poppler-Qt5]
    include-dirs = ["${poppler.dev}/include/poppler"]
    EOF
  '';

  # no tests, just bindings for `poppler_qt5`
  doCheck = false;
  pythonImportsCheck = [ "popplerqt5" ];

  dontWrapQtApps = true;

  meta = with lib; {
    homepage = "https://github.com/frescobaldi/python-poppler-qt5";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ ];
  };
}
