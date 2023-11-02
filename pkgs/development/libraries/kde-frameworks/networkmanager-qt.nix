{
  mkDerivation, lib,
  extra-cmake-modules,
  networkmanager, qtbase,
  fetchpatch
}:

mkDerivation {
  pname = "networkmanager-qt";

  # backport patches for NetworkManager 1.44 compatibility
  # FIXME: remove in 5.112
  patches = [
    (fetchpatch {
      url = "https://invent.kde.org/frameworks/networkmanager-qt/-/commit/d9a938ddbfb5800503935926301ff2865ab77a6d.patch";
      hash = "sha256-EjFBcU0YJQocp8skDZUTxCQhfrtQP5Fdo8q1BC9lLnQ=";
    })
    (fetchpatch {
      url = "https://invent.kde.org/frameworks/networkmanager-qt/-/commit/d35c6cb97443424d228dfd8eee8282af6632b5f5.patch";
      hash = "sha256-KmRcCjdHGGk+5PY5JKNbk0BHCtdwibns+Hw4aNRaoZI=";
    })
  ];

  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ networkmanager qtbase ];
  outputs = [ "out" "dev" ];
  meta.platforms = lib.platforms.linux;
}
