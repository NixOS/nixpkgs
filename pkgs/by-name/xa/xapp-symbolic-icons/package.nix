{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  python3,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "xapp-symbolic-icons";
<<<<<<< HEAD
  version = "1.0.7";
=======
  version = "1.0.5";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "xapp-project";
    repo = "xapp-symbolic-icons";
    tag = finalAttrs.version;
<<<<<<< HEAD
    hash = "sha256-zBU7LyINEKZB3F6AiQe5k5ZGJBdLJAaPXJhGudZ37eY=";
=======
    hash = "sha256-lzxNtalNNKTamoToHWXkqWUoPqQZiWvgETVqLF1ov8Q=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  buildInputs = [
    python3 # xsi-replace-adwaita-symbolic
  ];

  meta = {
    homepage = "https://github.com/xapp-project/xapp-symbolic-icons";
    description = "Set of symbolic icons for GTK applications and projects";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.cinnamon ];
  };
})
