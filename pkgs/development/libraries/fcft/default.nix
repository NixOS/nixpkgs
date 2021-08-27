{ stdenv, lib, fetchFromGitea, pkg-config, meson, ninja, scdoc
, freetype, fontconfig, pixman, tllist, check
, withHarfBuzz ? true
, harfbuzz
}:

let
  # Courtesy of sternenseemann and FRidh, commit c9a7fdfcfb420be8e0179214d0d91a34f5974c54
  mesonFeatureFlag = opt: b: "-D${opt}=${if b then "enabled" else "disabled"}";
in

stdenv.mkDerivation rec {
  pname = "fcft";
  version = "2.4.5";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "dnkl";
    repo = "fcft";
    rev = version;
    sha256 = "0z4bqap88pydkgcxrsvm3fmcyhi9x7z8knliarvdcvqlk7qnyzfh";
  };

  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [ pkg-config meson ninja scdoc ];
  buildInputs = [ freetype fontconfig pixman tllist ]
    ++ lib.optional withHarfBuzz harfbuzz;
  checkInputs = [ check ];

  mesonBuildType = "release";
  mesonFlags = [
    (mesonFeatureFlag "text-shaping" withHarfBuzz)
  ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://codeberg.org/dnkl/fcft";
    changelog = "https://codeberg.org/dnkl/fcft/releases/tag/${version}";
    description = "Simple library for font loading and glyph rasterization";
    maintainers = with maintainers; [
      fionera
      sternenseemann
    ];
    license = licenses.mit;
    platforms = with platforms; linux;
  };
}
