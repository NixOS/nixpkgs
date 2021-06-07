{ stdenv, lib, fetchzip, pkg-config, meson, ninja, scdoc
, freetype, fontconfig, pixman, tllist, check
, withHarfBuzz ? true
, harfbuzz
}:

stdenv.mkDerivation rec {
  pname = "fcft";
  version = "2.4.0";

  src = fetchzip {
    url = "https://codeberg.org/dnkl/fcft/archive/${version}.tar.gz";
    sha256 = "0z1r0s5s3dr1g4f3ylxfcmy3xb0ax02rw9mg7z8hzh0gxazrpndx";
  };

  nativeBuildInputs = [ pkg-config meson ninja scdoc ];
  buildInputs = [ freetype fontconfig pixman tllist ]
    ++ lib.optional withHarfBuzz harfbuzz;
  checkInputs = [ check ];

  mesonFlags = [
    "--buildtype=release"
    "-Dtext-shaping=${if withHarfBuzz then "enabled" else "disabled"}"
  ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://codeberg.org/dnkl/fcft";
    description = "Simple library for font loading and glyph rasterization";
    maintainers = with maintainers; [
      fionera
      sternenseemann
    ];
    license = licenses.mit;
    platforms = with platforms; linux;
  };
}
