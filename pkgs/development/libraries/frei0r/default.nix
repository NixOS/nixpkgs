{ lib, stdenv, fetchurl, fetchpatch, cairo, cmake, opencv, pcre, pkg-config }:

stdenv.mkDerivation rec {
  pname = "frei0r-plugins";
  version = "1.7.0";

  src = fetchurl {
    url = "https://files.dyne.org/frei0r/releases/${pname}-${version}.tar.gz";
    hash = "sha256-Gx/48Pm8I+7XJOlOmnwdjwJEv+M0JLtP5o5kYMCIUjo=";
  };

  # A PR to add support for OpenCV 4 was merged in May 2020. This
  # patch can be removed when a release beyond 1.7.0 is issued.
  patches = [
    (fetchpatch {
      name = "opencv4-support.patch";
      url = "https://github.com/dyne/frei0r/commit/c0c8eed79fc8abe6c9881a53d7391efb526a3064.patch";
      sha256 = "sha256-qxUAui4EEBEj8M/SoyMUkj//KegMTTT6FTBDC/Chxz4=";
    })
  ];

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ cairo opencv pcre ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    for f in $out/lib/frei0r-1/*.so* ; do
      ln -s $f "''${f%.*}.dylib"
    done
  '';

  meta = with lib; {
    homepage = "https://frei0r.dyne.org";
    description = "Minimalist, cross-platform, shared video plugins";
    license = licenses.gpl2;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux ++ platforms.darwin;

  };
}
