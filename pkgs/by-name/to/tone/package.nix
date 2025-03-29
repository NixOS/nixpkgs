{
  lib,
  fetchFromGitHub,
  buildDotnetModule,
  ffmpeg-full,
  dotnetCorePackages,
  versionCheckHook,
  nix-update-script,
}:

buildDotnetModule rec {
  pname = "tone";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "sandreas";
    repo = "tone";
    tag = "v${version}";
    hash = "sha256-DX54NSlqAZzVQObm9qjUsYatjxjHKGcSLHH1kVD4Row=";
  };

  projectFile = "tone/tone.csproj";
  executables = [ "tone" ];
  nugetDeps = ./deps.json;

  dotnetInstallFlags = [
    "-p:PublishSingleFile=false"
  ];

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.sdk_8_0;
  runtimeDeps = [ ffmpeg-full ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/sandreas/tone";
    description = "Cross platform utility to dump and modify audio metadata for a wide variety of formats";
    changelog = "https://github.com/sandreas/tone/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jvanbruegge jwillikers ];
    platforms = with lib.platforms; linux ++ darwin ++ windows;
    mainProgram = "tone";
  };
}
