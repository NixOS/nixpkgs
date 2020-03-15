{ stdenv
, fetchFromGitHub
, meson
, ninja
, sassc
, gtk3
, inkscape
, optipng
, gtk-engine-murrine
, gdk-pixbuf
, librsvg
}:

stdenv.mkDerivation rec {
  pname = "pop-gtk-theme";
  version = "2020-02-10";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "gtk-theme";
    rev = "ed888e9dd5de142cb899e362beedaf694594cc7e";
    sha256 = "0ryr1jx9pzij6pkv7sam07f90w5lbrzx0fj5vdxl94612mh76aad";
  };

  nativeBuildInputs = [
    meson
    ninja
    sassc
    gtk3
    inkscape
    optipng
  ];

  buildInputs = [
    gdk-pixbuf
    librsvg
  ];

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  postPatch = ''
    for file in $(find -name render-\*.sh); do
      patchShebangs "$file"

      substituteInPlace "$file" \
        --replace 'INKSCAPE="/usr/bin/inkscape"' \
                  'INKSCAPE="inkscape"' \
        --replace 'OPTIPNG="/usr/bin/optipng"' \
                  'OPTIPNG="optipng"'
    done
  '';

  meta = with stdenv.lib; {
    description = "System76 Pop GTK+ Theme";
    homepage = "https://github.com/pop-os/gtk-theme";
    license = with licenses; [ gpl3 lgpl21 cc-by-sa-40 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ elyhaka ];
  };
}
