{ stdenv, lib, fetchzip, pkg-config, meson, ninja, scdoc
, freetype, fontconfig, pixman, tllist, check
, withHarfBuzz ? true
, harfbuzz
}:

stdenv.mkDerivation rec {
  pname = "fcft";
  version = "2.4.3";

  src = fetchzip {
    url = "https://codeberg.org/dnkl/fcft/archive/${version}.tar.gz";
    sha256 = "0hxvd6xbvgq1rk8851gswffmvh3fv41lyvz4fhwzln7m12759yw8";
  };

  depsBuildBuild = [ pkg-config ];
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
