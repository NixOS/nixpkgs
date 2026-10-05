{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
}:

buildPythonPackage {
  pname = "google-play-scraper";
  version = "1.2.7-unstable-2024-06-07";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "JoMingyu";
    repo = "google-play-scraper";
    rev = "ce1df6d67e6d8c39826daac2f668808fc025f284";
    hash = "sha256-6JUizAU0FEw4z5rZfJREAfZn2dBKakXYsCWFXm0iEhs=";
  };

  build-system = [ poetry-core ];

  pythonImportsCheck = [ "google_play_scraper" ];

  # requires internet connection to google play
  doCheck = false;

  meta = {
    description = "Google play scraper for Python inspired by <facundoolano/google-play-scraper>";
    homepage = "https://github.com/JoMingyu/google-play-scraper";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ felbinger ];
  };
}
