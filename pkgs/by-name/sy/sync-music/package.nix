{ lib
, python3Packages
, fetchFromGitHub
, ffmpeg
, mutagen
}:

python3Packages.buildPythonPackage rec {
  pname = "sync-music";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fetzerch";
    repo = "sync_music";
    rev = "v${version}";
    hash = "sha256-8vDSTaTQvdADTSxbfSxgCDsFbGPD5RtQGURv3LTwGXQ=";
  };

  patches = [
    ./uppercase_mp3_tags.patch # Fixes uppercase replaygain metadat bug https://github.com/fetzerch/sync_music/pull/18
  ];

  propagatedBuildInputs = [
    python3Packages.mutagen
    python3Packages.pbr
    python3Packages.setuptools
    ffmpeg
  ];

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
    python3Packages.tox
    python3Packages.pytest-mock
    ffmpeg
  ];

  # Manually set version because prb wants to get it from the git
  # upstream repository (and we are installing from tarball instead)
  env.PBR_VERSION = version;

  setuptoolsCheckPhase = "true";

  meta = with lib; {
    description = " Sync music library to external devices";
    homepage = "https://github.com/fetzerch/sync_music";
    changelog = "https://github.com/fetzerch/sync_music/releases/tag/${src.rev}";
    mainProgram = "sync_music";
    maintainers = [ maintainers.gaykitty ];
    license = licenses.gpl2Plus;
  };
}
