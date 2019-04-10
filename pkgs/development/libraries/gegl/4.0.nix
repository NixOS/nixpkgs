{ stdenv, fetchurl, fetchpatch, pkgconfig, glib, babl, libpng, cairo, libjpeg, which
, librsvg, pango, gtk, bzip2, json-glib, gettext, autoreconfHook, libraw
, gexiv2, libwebp, gnome3, libintl }:

stdenv.mkDerivation rec {
  pname = "gegl";
  version = "0.4.14";

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "dev";

  src = fetchurl {
    url = "https://download.gimp.org/pub/gegl/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
    sha256 = "00crhngwi07f5b9x77kx5p7p4cl6l5g6glpz9rqv7pfqk62xa0ac";
  };

  patches = stdenv.lib.optionals stdenv.isDarwin [
    # Make the Darwin patches below apply cleanly
    (fetchpatch {
      url = https://gitlab.gnome.org/GNOME/gegl/commit/141a7aa76cd36143f624f06b1c43d2483945653c.patch;
      sha256 = "0ijv9ra6723jn60krjwzbc6l9qr08h76bsz9xgddvfgsgr1nnpbi";
    })
    (fetchpatch {
      url = https://gitlab.gnome.org/GNOME/gegl/commit/b3ff0df080d133bbdb394c3db40d4f9d2980a8a6.patch;
      sha256 = "0im0rqk8mz9vi7qqx06vj4wm5hjwv1544jwdaaywlcrs9g266hl0";
    })
    (fetchpatch {
      url = https://gitlab.gnome.org/GNOME/gegl/commit/fe756be6f0c776a45201a61f67d3e5e42f6398de.patch;
      sha256 = "0h3rqwfsph2gisbwvc2v5a9r5b0djcxlm790xpi6yfndj42b0v2b";
    })
    # Fix build on Darwin
    # https://gitlab.gnome.org/GNOME/gegl/merge_requests/28
    (fetchpatch {
      url = https://gitlab.gnome.org/GNOME/gegl/commit/ac331b5c0e3d940b64bb811b0f54e86c7d312917.patch;
      sha256 = "1yj9jh8q9cbr1szrxhdapknk4nfhbkbc1njv50ifrj7vyfislj34";
    })
    (fetchpatch {
      url = https://gitlab.gnome.org/GNOME/gegl/commit/d05eb01170728f45f561ca937708a293e29e02d9.patch;
      sha256 = "0gwz12sm8kkmzyxsiq0sl30cabs5q0ckj743yrzimspkhrvc1ya2";
    })
  ];

  enableParallelBuilding = true;

  doCheck = true;

  buildInputs = [
    libpng cairo libjpeg librsvg pango gtk bzip2
    libraw libwebp gexiv2
  ];

  propagatedBuildInputs = [ glib json-glib babl ]; # for gegl-4.0.pc

  nativeBuildInputs = [ pkgconfig gettext which autoreconfHook libintl ];

  meta = with stdenv.lib; {
    description = "Graph-based image processing framework";
    homepage = http://www.gegl.org;
    license = licenses.gpl3;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
