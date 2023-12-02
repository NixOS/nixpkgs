{ lib
, stdenv
, fetchurl
, fetchpatch
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

  patches = [
    # Fix compilation with libxml 2.12.
    (fetchpatch {
      url = "https://github.com/libxmlplusplus/libxmlplusplus/commit/1a5ec5cacf515bda4d655b2f20a65f4ca7e9b886.patch";
      hash = "sha256-voGKykSjTUdNRNvMct0EI4ArANnyDXgyAgUM46sGbnk=";
    })
  ];

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
