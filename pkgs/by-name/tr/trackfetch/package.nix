{
  lib,
  python3Packages,
  fetchFromGitHub,
  runCommand,
  nix-update-script,
  ffmpeg,
  deno,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "trackfetch";
  version = "2.0.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ByteMe6";
    repo = "trackfetch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2GeahYP1DPb9joGYPs5ls3c/j6af7ufgX/YoOL+Abv4=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    mutagen
    requests
    spotipy
    yt-dlp
  ];

  # trackfetch runs these as external programs.
  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      python3Packages.yt-dlp
      ffmpeg
      deno
    ])
  ];

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

  pythonImportsCheck = [ "trackfetch" ];

  passthru = {
    tests = {
      help = runCommand "trackfetch-test-help" { } ''
        ${lib.getExe finalAttrs.finalPackage} --help | tee $out
        grep -q "usage: trackfetch" $out
      '';

      missing-credentials = runCommand "trackfetch-test-missing-credentials" { } ''
        echo "Artist - Title" > songs.txt
        if ${lib.getExe finalAttrs.finalPackage} songs.txt -o out > log 2>&1; then
          echo "trackfetch succeeded without Spotify credentials" >&2
          exit 1
        fi
        grep -q "Spotify credentials not found" log
        cp log $out
      '';
    };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Turn a text file of songs into tagged MP3s using Spotify metadata and YouTube audio";
    homepage = "https://github.com/ByteMe6/trackfetch";
    changelog = "https://github.com/ByteMe6/trackfetch/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ByteMe6 ];
    mainProgram = "trackfetch";
  };
})
