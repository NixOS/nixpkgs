{ fetchgit
, stdenv
, meson
, ninja
, cmake
, pkgconfig
, gobject-introspection
, xrdesktop
, vulkan-headers
, vulkan-loader
, gulkan
, gtk3
, json-glib
, openxr-loader
, glew
, glfw3
, cairo
, xorg
}:

stdenv.mkDerivation rec {
  pname = "gxr";
  version = xrdesktop.version;
  
  src = fetchgit {
    url = "https://gitlab.freedesktop.org/xrdesktop/gxr.git";
    rev = version;
    sha256 = "1rd9a349grydi0x22f38dfjr1q8a7p4m3hlpm2mzj7qvibblajq0";
  };
  
  propagatedBuildInputs = [
    gtk3
    gulkan
    vulkan-headers
    vulkan-loader
    openxr-loader
    json-glib
    glew
    glfw3
    cairo
    xorg.libXtst
    xorg.libX11
  ];
  
  nativeBuildInputs = [
    meson
    ninja
    cmake
    pkgconfig
    gobject-introspection
  ];
}
