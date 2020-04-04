{ fetchgit
, stdenv
, meson
, ninja
, cmake
, pkgconfig
, gobject-introspection
, cairo
, gtk3
, gdk-pixbuf
, gxr
, python3
, python38Packages
}:

stdenv.mkDerivation rec {
  pname = "xrdesktop";
  version = "0.14.0";
  
  src = fetchgit {
    url = "https://gitlab.freedesktop.org/xrdesktop/xrdesktop.git";
    rev = version;
    sha256 = "0zzg53rlccyyndy8v7k2qs7j9xsa4hfm96g8lxqar63w3ivrqcss";
  };
  
  propagatedBuildInputs = [
    gtk3
    cairo
    gdk-pixbuf
    gxr
    (python3.withPackages(ps: with ps; [ pygobject3 ]))
    python38Packages.pygobject3
  ];
  
  nativeBuildInputs = [
    meson
    ninja
    cmake
    pkgconfig
    gobject-introspection
  ];

}

