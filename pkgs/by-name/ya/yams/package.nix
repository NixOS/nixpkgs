{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "yams";
  # nixpkgs-update: no auto update
  version = "0.7.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Berulacks";
    repo = "yams";
    tag = finalAttrs.version;
    hash = "sha256-CMqYSlzKEKcJUup2SVAOe9qdQTJWEfHVlEaDmLRncP4=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    pyyaml
    psutil
    python-mpd2
    requests
  ];

  pythonImportsCheck = [ "yams.scrobble" ];

  meta = {
    homepage = "https://github.com/Berulacks/yams";
    description = "Last.FM scrobbler for MPD";
    mainProgram = "yams";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      acidbong
    ];
  };
})
