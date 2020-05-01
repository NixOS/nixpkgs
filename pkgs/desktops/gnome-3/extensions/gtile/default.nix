{ stdenv, fetchFromGitHub, glib }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-gtile";
  version = "34";

  src = fetchFromGitHub {
    owner = "gTile";
    repo = "gTile";
    rev = "V${version}";
    sha256 = "1yka4acmrykh4vdd89yvn6yv89c6q16r72lgi3j48my3jghwjiwp";
  };

  uuid = "gTile@vibou";

  nativeBuildInputs = [ glib ];

  installPhase = ''
    mkdir -p $out/share/gnome-shell/extensions/$uuid
    cp -r * $out/share/gnome-shell/extensions/$uuid

    schemadir=${glib.makeSchemaPath "$out" "${pname}-${version}"}
    mkdir -p $schemadir
    cp -r $out/share/gnome-shell/extensions/$uuid/schemas/* $schemadir
  '';

  meta = with stdenv.lib; {
    description = "GNOME shell extension to move/resize windows on a configurable grid scheme";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.firmero ];
    homepage = "https://github.com/gTile/gTile";
  };
}
