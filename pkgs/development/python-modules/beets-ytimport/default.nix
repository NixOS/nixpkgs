{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  ytmusicapi,
  yt-dlp,
  beets-minimal,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:
buildPythonPackage rec {
  pname = "beets-ytimport";
  version = "1.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mgoltzsche";
    repo = "beets-ytimport";
    tag = "v${version}";
    hash = "sha256-EwSL1rBEPTcMfrlTkQcqRuhR8OtibBZqA0qQz4+qLEw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    ytmusicapi
    yt-dlp
  ];

  nativeBuildInputs = [
    beets-minimal
  ];

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
    pytestCheckHook
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/mgoltzsche/beets-ytimport/releases/tag/v${version}";
    description = "Beets plugin to import music from Youtube and SoundCloud";
    homepage = "https://github.com/mgoltzsche/beets-ytimport";
    maintainers = with lib.maintainers; [ pyrox0 ];
    license = [ lib.licenses.asl20 ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
