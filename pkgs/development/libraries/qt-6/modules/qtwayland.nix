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
    # Included in qtwayland 6.7.3
    # Fixes https://bugs.kde.org/show_bug.cgi?id=489259
    (fetchpatch {
      url = "https://invent.kde.org/qt/qt/qtwayland/-/commit/92bcb8f6b7a852c7a5d662fc34de561692a7a454.diff";
      sha256 = "sha256-XgGO8VnmQHLhUxTGf9CniwkCr5FsFiuUbnVP0NLNekI=";
    })
  ];
}
