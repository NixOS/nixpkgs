{ qtModule
, qtbase
, qtdeclarative
, wayland
, wayland-scanner
, pkg-config
, libdrm
, fetchpatch
}:

qtModule {
  pname = "qtwayland";
  # wayland-scanner needs to be propagated as both build
  # (for the wayland-scanner binary) and host (for the
  # actual wayland.xml protocol definition)
  propagatedBuildInputs = [ qtbase qtdeclarative wayland-scanner ];
  propagatedNativeBuildInputs = [ wayland wayland-scanner ];
  buildInputs = [ wayland libdrm ];
  nativeBuildInputs = [ pkg-config ];

  patches = [
    # Update wayland.xml to version 1.23.0
    (fetchpatch {
      url = "https://invent.kde.org/qt/qt/qtwayland/-/commit/c2f61bc47baacf2e6a44c6c3c4e4cbf0abfa4095.diff";
      sha256 = "sha256-ZcK/LT65oFvTzCukZB8aDYWH5L6RK5MOPs8VtpYQpq0=";
    })
  ];
}
