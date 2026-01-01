{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "mediainfo.yazi";
<<<<<<< HEAD
  version = "25.5.31-unstable-2025-12-04";
=======
  version = "25.5.31-unstable-2025-11-15";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "boydaihungst";
    repo = "mediainfo.yazi";
<<<<<<< HEAD
    rev = "af8bdf47a1f4dcfefe433aa2134b04eb9c75a10b";
    hash = "sha256-io3HyoUniWZu+0efZfbhXn8JoG5p2/lFeH/FguVvjSY=";
=======
    rev = "1099409ca956282efe49dea8ab53f8be95feb72a";
    hash = "sha256-K2SHIzmNtICgVchSPB1mtTboyvDPIq+hN3GEOR20hpk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  meta = {
    description = "Yazi plugin for previewing media files";
    homepage = "https://github.com/boydaihungst/mediainfo.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
