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
, python3
}:

stdenv.mkDerivation rec {
  pname = "pop-gtk-theme";
  version = "2020-04-22";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "gtk-theme";
    rev = "b3f98dfd61cfff81f69cdc7f57bce7a9efaa36f4";
    sha256 = "0vhcc694x33sgcpbqkrc5bycbd7017k4iii0mjjxgd22jd5lzgkb";
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
