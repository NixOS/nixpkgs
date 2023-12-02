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
  version = "3.2.4";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/libxml++/${lib.versions.majorMinor finalAttrs.version}/libxml++-${finalAttrs.version}.tar.xz";
    hash = "sha256-ulP16spFt59OwbOyi8gTb84mhzzTjy44HZNVKJ5DJAU=";
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
      attrPath = "libxmlxx3";
      packageName = "libxml++";
      versionPolicy = "odd-unstable";
      freeze = true;
    };
  };

  meta = with lib; {
    homepage = "https://libxmlplusplus.github.io/libxmlplusplus/";
    description = "C++ wrapper for the libxml2 XML parser library, version 3";
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ loskutov ];
  };
})
