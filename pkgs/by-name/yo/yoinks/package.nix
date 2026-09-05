{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  ffmpeg,
  yt-dlp,
}:

buildNpmPackage (finalAttrs: {
  pname = "yoinks";
  version = "0.3.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pablostanley";
    repo = "yoinks";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CxijcAkRSddWo5hA7Wt0w6ouWFQZAxbLUh5gKJtr3P8=";
  };

  npmDepsHash = "sha256-PhzO6pKzSO+q1GHes3TQ74X0+sEYEhlbvT9MRHg98fg=";
  nativeBuildInputs = [ ffmpeg ];

  postInstall = ''
    ln -sf ${lib.getExe ffmpeg} $out/lib/node_modules/yoinks/node_modules/ffmpeg-static/ffmpeg
    wrapProgram $out/bin/yoinks \
      --prefix PATH : ${lib.makeBinPath [ yt-dlp ]}
  '';

  env.FFMPEG_BIN = "${lib.getExe ffmpeg}";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "yoink any video from YouTube, X, Instagram, Threads & 1800+ sites — right from your terminal. paste. yoink. done.";
    homepage = "https://github.com/pablostanley/yoinks";
    license = lib.licenses.mit;
    mainProgram = "yoinks";
    maintainers = [ lib.maintainers.airone01 ];
  };
})
