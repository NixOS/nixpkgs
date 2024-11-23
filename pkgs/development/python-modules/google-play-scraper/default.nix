{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  poetry-core,
}:

buildPythonPackage {
  pname = "google-play-scraper";
  version = "1.2.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "JoMingyu";
    repo = "google-play-scraper";
    rev = "ce1df6d67e6d8c39826daac2f668808fc025f284";
    hash = "sha256-6JUizAU0FEw4z5rZfJREAfZn2dBKakXYsCWFXm0iEhs=";
  };

  build-system = [ poetry-core ];

  # This package has tests, but almost all of them require an
  # internet connection
  pythonImportsCheck = [ "google_play_scraper" ];

  meta = {
    description = "Google-Play-Scraper provides APIs to easily crawl the Google Play Store for Python without any external dependencies!";
    homepage = "https://github.com/JoMingyu/google-play-scraper/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gamedungeon ];
  };
}
