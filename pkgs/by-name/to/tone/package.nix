{
  lib,
  fetchFromGitHub,
  buildDotnetModule,
  ffmpeg-full,
  dotnetCorePackages,
  versionCheckHook,
}:

buildDotnetModule rec {
  pname = "tone";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "sandreas";
    repo = "tone";
    rev = "v${version}";
    hash = "sha256-HhXyOPoDtraT7ef0kpE7SCQbvGFLrTddzS6Kdu0LxW4=";
  };

  projectFile = "tone/tone.csproj";
  executables = [ "tone" ];
  nugetDeps = ./deps.nix;

  dotnetInstallFlags = [
    "-p:PublishSingleFile=false"
  ];

  dotnet-sdk = dotnetCorePackages.sdk_6_0;
  dotnet-runtime = dotnetCorePackages.sdk_6_0;
  runtimeDeps = [ ffmpeg-full ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://github.com/sandreas/tone";
    description = "Cross platform utility to dump and modify audio metadata for a wide variety of formats";
    changelog = "https://github.com/sandreas/tone/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jvanbruegge ];
    platforms = lib.platforms.linux;
    mainProgram = "tone";
  };
}
