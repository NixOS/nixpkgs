{ fetchgit
, stdenv
, meson
, ninja
, cmake
, pkgconfig
, gobject-introspection
, xrdesktop
, gtk3
, gdk-pixbuf
, cairo
, graphene
, vulkan-headers
, vulkan-loader
, glew
, glfw3
, shaderc
, json-glib
}:

stdenv.mkDerivation rec {
  pname = "gulkan";
  version = xrdesktop.version;
  
  src = fetchgit {
    url = "https://gitlab.freedesktop.org/xrdesktop/gulkan.git";
    rev = version;
    sha256 = "12n5d259mh5h58yi26g2jq0dhybw2gwx7ha75jmlrnq3ccrkfb00";
  };
  
  propagatedBuildInputs = [
    gtk3
    gdk-pixbuf
    cairo
    graphene
    vulkan-headers
    vulkan-loader
    glew
    glfw3
    shaderc
    json-glib
    gobject-introspection
  ];
  
  nativeBuildInputs = [
    meson
    ninja
    cmake
    pkgconfig
    gobject-introspection
  ];
}
