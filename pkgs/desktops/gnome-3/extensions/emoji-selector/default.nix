{ stdenv, fetchFromGitHub, glib, gettext }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-emoji-selector";
  version = "19";

  src = fetchFromGitHub {
    owner = "maoschanz";
    repo = "emoji-selector-for-gnome";
    rev = version;
    sha256 = "0x60pg5nl5d73av494dg29hyfml7fbf2d03wm053vx1q8a3pxbyb";
  };

  uuid = "emoji-selector@maestroschan.fr";

  nativeBuildInputs = [ glib ];

  buildPhase = ''
    runHook preBuild
    glib-compile-schemas ./${uuid}/schemas
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions
    cp -r ${uuid} $out/share/gnome-shell/extensions
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description =
      "GNOME Shell extension providing a searchable popup menu displaying most emojis";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ rawkode ];
    homepage = "https://github.com/maoschanz/emoji-selector-for-gnome";
  };
}
