{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "twitch-chat-downloader";
  version = "2.5.6";
  pyproject = true;

  # NOTE: Using maintained fork because upstream has stopped working, and it has
  # not been updated in a while.
  # https://github.com/PetterKraabol/Twitch-Chat-Downloader/issues/142
  src = fetchFromGitHub {
    owner = "TheDrHax";
    repo = "twitch-chat-downloader";
    rev = finalAttrs.version;
    hash = "sha256-OhnAUboA/LjiB7AVqbNEVZIDSMePV1kOsMZPFB43S44=";
  };

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    iso8601
    progressbar2
    requests
  ];

  doCheck = false; # no tests

  pythonImportsCheck = [ "tcd" ];

  meta = {
    description = "Twitch Chat Downloader";
    mainProgram = "tcd";
    homepage = "https://github.com/TheDrHax/Twitch-Chat-Downloader";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ assistant ];
  };
})
