{
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  lib,
  versionCheckHook,
  nix-update-script,
}:

buildDotnetModule rec {
  pname = "vrcadvert";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "galister";
    repo = "VrcAdvert";
    tag = "v${version}";
    hash = "sha256-lrRH+BBeVpYVAdFdlsYVxsBOENZseBVoAxb5v9+E7g8=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;
  dotnetFlags = [ "-p:RuntimeFrameworkVersion=${dotnet-runtime.version}" ];

  nugetDeps = ./deps.json;

  executables = [ "VrcAdvert" ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/VrcAdvert";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Advertise your OSC app through OSCQuery";
    homepage = "https://github.com/galister/VrcAdvert";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ Scrumplex ];
    mainProgram = "VrcAdvert";
    platforms = lib.platforms.all;
  };
}
