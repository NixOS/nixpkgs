{ lib, stdenv
, fetchurl
, meson
, ninja
, pkg-config
, gobject-introspection
, lcms2
, vala
}:

stdenv.mkDerivation rec {
  pname = "babl";
  version = "0.1.86";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "https://download.gimp.org/pub/babl/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-Cz9ZUVmtGyFs1ynAUEw6X2z3gMZB9Nxj/BZPPAOCyPA=";
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
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
