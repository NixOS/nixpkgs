{ stdenv
, fetchFromGitHub
, meson
, ninja
, sassc
, gtk3
, inkscape_0
, optipng
, gtk-engine-murrine
, gdk-pixbuf
, librsvg
, python3
}:

stdenv.mkDerivation rec {
  pname = "pop-gtk-theme";
  version = "2020-06-30";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "gtk-theme";
    rev = "8c31be9f9257375bf7a049069cb4ecbac7d281a1";
    sha256 = "16dxxazpllcxlbiblynqq4b65wfn9k1jab8dl69l819v73z303ky";
  };

  nativeBuildInputs = [
    meson
    ninja
    sassc
    gtk3
    inkscape_0
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
                  'INKSCAPE="${inkscape_0}/bin/inkscape"' \
        --replace 'OPTIPNG="/usr/bin/optipng"' \
                  'OPTIPNG="${optipng}/bin/optipng"'
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
