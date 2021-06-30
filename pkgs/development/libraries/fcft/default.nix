{ stdenv, lib, fetchzip, pkg-config, meson, ninja, scdoc
, freetype, fontconfig, pixman, tllist, check
, withHarfBuzz ? true
, harfbuzz
}:

stdenv.mkDerivation rec {
  pname = "fcft";
  version = "2.4.1";

  src = fetchzip {
    url = "https://codeberg.org/dnkl/fcft/archive/${version}.tar.gz";
    sha256 = "sha256-QxAp6pnZPLPwarurbKovz0BVOO4XdckBzjB65XCBPAM=";
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
