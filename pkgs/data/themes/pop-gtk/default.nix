{ lib
, stdenv
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
, python3
}:

stdenv.mkDerivation rec {
  pname = "pop-gtk-theme";
  version = "2021-08-19";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "gtk-theme";
    rev = "6615e4510485c5dc0b379746acc40f538d987c86";
    sha256 = "16h03x2m4j4hfwp7pdmw1navcy5q7di38jvigfgf263wajyxbznr";
  };

  nativeBuildInputs = [
    meson
    ninja
    sassc
    gtk3
    inkscape
    optipng
    python3
  ];

  buildInputs = [
    gdk-pixbuf
    librsvg
  ];

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  postPatch = ''
    patchShebangs .

    for file in $(find -name render-\*.sh); do
      substituteInPlace "$file" \
        --replace 'INKSCAPE="/usr/bin/inkscape"' \
                  'INKSCAPE="${inkscape}/bin/inkscape"' \
        --replace 'OPTIPNG="/usr/bin/optipng"' \
                  'OPTIPNG="${optipng}/bin/optipng"'
    done
  '';

  meta = with lib; {
    description = "System76 Pop GTK+ Theme";
    homepage = "https://github.com/pop-os/gtk-theme";
    license = with licenses; [ gpl3 lgpl21 cc-by-sa-40 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
