{
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  lib,
  versionCheckHook,
}:

buildDotnetModule rec {
  pname = "vrcadvert";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "galister";
    repo = "VrcAdvert";
    rev = "refs/tags/v${version}";
    hash = "sha256-noIu5LV0yva94Kmdr39zb0kKXDaIrQ8DIplCj3aTIbQ=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;
  dotnetFlags = [ "-p:RuntimeFrameworkVersion=${dotnet-runtime.version}" ];

  nugetDeps = ./deps.json;

  executables = [ "VrcAdvert" ];

  postPatch = ''
    substituteInPlace VrcAdvert.csproj \
      --replace-fail 'net6.0' 'net8.0'
    substituteInPlace global.json \
      --replace-fail '6.0.0' '8.0.0'
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/VrcAdvert";

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Advertise your OSC app through OSCQuery";
    homepage = "https://github.com/galister/VrcAdvert";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ Scrumplex ];
    mainProgram = "VrcAdvert";
    platforms = lib.platforms.all;
  };
}
