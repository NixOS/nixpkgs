{ lib
, stdenv
, fetchurl
, pkg-config
, libxml2
, glibmm
, meson
, ninja
, gnome
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libxml++";
  version = "2.42.2";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/libxml++/${lib.versions.majorMinor finalAttrs.version}/libxml++-${finalAttrs.version}.tar.xz";
    hash = "sha256-pDOYf1TMHsqoSvJq8EemLfnohFdODWhuXdxvcEQcFSs=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];

  propagatedBuildInputs = [
    libxml2
    glibmm
  ];

  passthru = {
    updateScript = gnome.updateScript {
      attrPath = "libxmlxx";
      packageName = "libxml++";
      versionPolicy = "odd-unstable";
      freeze = true;
    };
  };

  meta = with lib; {
    homepage = "https://libxmlplusplus.github.io/libxmlplusplus/";
    description = "C++ wrapper for the libxml2 XML parser library";
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ];
  };
})
