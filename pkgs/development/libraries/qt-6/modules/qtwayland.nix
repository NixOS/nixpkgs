{ qtModule
, qtbase
, qtdeclarative
, wayland
, pkg-config
, libdrm
, fetchpatch
}:

qtModule {
  pname = "qtwayland";
  propagatedBuildInputs = [ qtbase qtdeclarative ];
  buildInputs = [ wayland libdrm ];
  nativeBuildInputs = [ pkg-config ];
  patches = [
    # Fix potential crash issues when some submenus are expanded
    # https://codereview.qt-project.org/c/qt/qtwayland/+/519344/
    (fetchpatch {
      url = "https://code.qt.io/cgit/qt/qtwayland.git/patch/?id=aae65c885d8e38d8abc2959cded7b5e9e5fc88b3";
      hash = "sha256-FD1VaiTgl9Z1y+5EDpWYShM1ULoFdET86FoFfqDmjyo=";
    })
  ];
}
