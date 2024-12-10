{
  qtModule,
  qtbase,
  qtdeclarative,
  wayland,
  pkg-config,
  libdrm,
  fetchpatch,
}:

qtModule {
  pname = "qtwayland";
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
  ];
  buildInputs = [
    wayland
    libdrm
  ];
  nativeBuildInputs = [ pkg-config ];

  patches = [
    # Included in qtwayland 6.7.3
    # Fixes https://bugs.kde.org/show_bug.cgi?id=489259
    (fetchpatch {
      url = "https://invent.kde.org/qt/qt/qtwayland/-/commit/92bcb8f6b7a852c7a5d662fc34de561692a7a454.diff";
      sha256 = "sha256-XgGO8VnmQHLhUxTGf9CniwkCr5FsFiuUbnVP0NLNekI=";
    })

    # Included in qtwayland 6.7.3
    # Fixes https://bugs.kde.org/show_bug.cgi?id=489072
    (fetchpatch {
      url = "https://invent.kde.org/qt/qt/qtwayland/-/commit/c4f91b479303dda2e49499de249018d7c66c5f99.diff";
      sha256 = "sha256-4rUdl6WuJHONW0Uy2wjTvyvDY3bJWeRvhk3tCkaOOro=";
    })

    # Included in qtwayland 6.7.3
    # Fixes https://bugs.kde.org/show_bug.cgi?id=489180
    (fetchpatch {
      url = "https://invent.kde.org/qt/qt/qtwayland/-/commit/632127d7f1d86cba4dd17361f24f9fd70a0ae44c.diff";
      sha256 = "sha256-1EIcMj6+yIpqXAGZB3ZbrwRkl4n1o7TVP2SC1Nu1t78=";
    })
  ];
}
