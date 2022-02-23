{ stdenv
, lib
, fetchurl
, fetchpatch
, meson
, ninja
, pkg-config
, gobject-introspection
, lcms2
, vala
}:

stdenv.mkDerivation rec {
  pname = "babl";
  version = "0.1.90";

  outputs = [ "out" "dev" ];

  patches = [
    # Fix darwin build
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/babl/-/commit/33b18e74c9589fd4d5507ab88bd1fb19c15965dd.patch";
      sha256 = "bEjjOjHGTF55o1z31G9GNDqERxn/7vUuWZQYHosSEBQ=";
    })
  ];

  src = fetchurl {
    url = "https://download.gimp.org/pub/babl/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-bi67Y283WBWI49AkmbPS9p+axz40omL0KRHX9ZBqkkM=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    vala
  ];

  buildInputs = [
    lcms2
  ];

  meta = with lib; {
    description = "Image pixel format conversion library";
    homepage = "https://gegl.org/babl/";
    changelog = "https://gitlab.gnome.org/GNOME/babl/-/blob/BABL_${lib.replaceStrings [ "." ] [ "_" ] version}/NEWS";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
