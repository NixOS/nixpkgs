{
  lib,
  fetchFromGitHub,
  pillow,
  buildPythonPackage,
  poetry-core,
  requests,
  pylette,
  lrclibapi,
  fonttools,
  questionary,
  rich,
  toml,
}:
buildPythonPackage rec {
  pname = "BeatPrints";
  version = "1.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "TrueMyst";
    repo = "BeatPrints";
    rev = "v${version}";
    hash = "sha256-KDMt+B3tyh/20N2We82ya90xZJAhCkvbdnTgZDw1GYg=";
  };

  build-system = [
    poetry-core
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "pillow = \">=9.3,<11.0\"" "Pillow = \"^11\""
  '';

  dependencies = [
    requests
    pylette
    lrclibapi
    fonttools
    questionary
    rich
    toml
    pillow
  ];

  meta = with lib; {
    description = "Create eye-catching, Pinterest-style music posters effortlessly";
    longDescription = ''
      Create eye-catching, Pinterest-style music posters effortlessly. BeatPrints integrates with Spotify and LRClib API to help you design custom posters for your favorite tracks or albums. 🍀
    '';
    homepage = "https://beatprints.readthedocs.io";
    changelog = "https://github.com/TrueMyst/BeatPrints/releases/tag/v${version}";
    mainProgram = "beatprints";
    license = licenses.cc-by-nc-sa-40;
    maintainers = with maintainers; [ DataHearth ];
    platforms = platforms.all;
  };
}
